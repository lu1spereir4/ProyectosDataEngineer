DROP TABLE IF EXISTS fct_transactions;
DROP TABLE IF EXISTS dim_hour;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_merchant;
DROP TABLE IF EXISTS dim_customer;


-- Dimensión de Hora
CREATE TABLE dim_hour (
    hour_sk SMALLINT PRIMARY KEY,
    hour_24 SMALLINT NOT NULL,
    is_am BOOLEAN NOT NULL,
    time_segment TEXT NOT NULL
);

INSERT INTO dim_hour
SELECT 
    h AS hour_sk,
    h AS hour_24,
    CASE WHEN h < 12 THEN TRUE ELSE FALSE END AS is_am,
    CASE 
        WHEN h BETWEEN 0 AND 5 THEN 'Madrugada'
        WHEN h BETWEEN 6 AND 11 THEN 'Mañana'
        WHEN h BETWEEN 12 AND 17 THEN 'Tarde'
        ELSE 'Noche'
    END AS time_segment
FROM generate_series(0, 23) h;

-- 24 filas --

-- Dimensión de Fecha
-- 2. Poblado dinámico
INSERT INTO dim_date (
    date_sk, 
    date, 
    year, 
    month, 
    day, 
    day_of_week, 
    is_weekend, 
    quarter, 
    month_name
)
SELECT 
    CAST(TO_CHAR(d, 'YYYYMMDD') AS INTEGER) AS date_sk,
    d::DATE AS date,
    EXTRACT(YEAR FROM d)::SMALLINT AS year,
    EXTRACT(MONTH FROM d)::SMALLINT AS month,
    EXTRACT(DAY FROM d)::SMALLINT AS day,
    EXTRACT(DOW FROM d)::SMALLINT AS day_of_week,
    CASE WHEN EXTRACT(DOW FROM d) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend,
    EXTRACT(QUARTER FROM d)::SMALLINT AS quarter,
    TO_CHAR(d, 'TMMonth') AS month_name -- 'TM' para que respete el idioma local
FROM generate_series(
    (SELECT MIN(trans_date_trans_time)::DATE FROM raw_transactions), -- Límite inferior dinámico
    (SELECT MAX(trans_date_trans_time)::DATE FROM raw_transactions), -- Límite superior dinámico
    '1 day'::interval
) d;


/*
SELECT * FROM dim_date
ORDER BY date;
la fecha minima es el 19-01-2019, la tendremos para ponerla como default en start_date 
para el cliente en sus atributos scd tipo 2
538 filas, que representan primera y ultima transaccion, ideal para tener los dias justos y no procesar de mas --
*/

/* Dimensiones dim_merchant, dim_customer

CREATE TABLE dim_merchant (
    merchant_sk SERIAL PRIMARY KEY,
    merchant_name TEXT NOT NULL,
    category TEXT NOT NULL,
    merch_lat NUMERIC(10,6),
    merch_long NUMERIC(10,6),
    merch_zipcode NUMERIC(10,1)
);

INSERT INTO dim_merchant (merchant_name, category, merch_lat, merch_long, merch_zipcode)
SELECT  
    REPLACE(merchant, 'fraud_', '') AS merchant_name, 
    category,
    merch_lat,
    merch_long,
    merch_zipcode
FROM raw_transactions;

-- 1296675 de mercados, esto esta mal, perdimos en sentido de la tabla dimensional
-- para mercado, el grano es una tienda y su categoria, si todas las lat y long
-- son distintas, al cruzar los datos con la tabla de hechos explotara la consulta

*/

CREATE TABLE dim_merchant (
    merchant_sk SERIAL PRIMARY KEY,
    merchant_name TEXT NOT NULL,
    category TEXT NOT NULL
);

/*
Importante la diferencia entre DISTINCT y DISCTICT ON
DISTINCT en este caso nos traeria 700 filas, ya que 7 mercados tienen mas 
de 1 categoria, haciendo que en la tabla de hechos algunos valores esten duplicados...

DISTINCT ON nos asegura de que sean filas unicas, traera el mercado con la primera cateoria que encuentre

Se penso en bridge table pero para este caso como son 7 valores de 693 
no se realizo porque estariamos entrando a normalizar o sobreingenieria

INSERT INTO dim_merchant (merchant_name, category)
SELECT DISTINCT
    REPLACE(merchant, 'fraud_', '') AS merchant_name, 
     category -- forzamos a que se escoga una categroia por comercio
FROM raw_transactions;
SELECT * FROM dim_merchant
ORDER BY merchant_name;
*/ 


INSERT INTO dim_merchant (merchant_name, category)
SELECT DISTINCT ON (REPLACE(merchant, 'fraud_', '')) -- Asegura 1 fila por nombre
    REPLACE(merchant, 'fraud_', '') AS merchant_name, 
    category
FROM raw_transactions
ORDER BY REPLACE(merchant, 'fraud_', ''), category;

-- 693 mercados con su categoria


CREATE TABLE dim_customer (
    customer_sk BIGSERIAL PRIMARY KEY,
    cc_num BIGINT NOT NULL, -- para identificar transacciones nos sirve
    first_name TEXT,
    last_name TEXT,
    gender CHAR(1),
    street TEXT,
    city TEXT,
    state TEXT,
    zip INT,
    city_pop INT,
    job TEXT,
    dob DATE,
    is_current BOOLEAN DEFAULT TRUE, -- al ser la primera carga del pipeline
    start_date DATE DEFAULT '2019-01-01', -- fecha mas antigua en la raw_transactions
    end_date DATE -- segun el estandar de Kimball 'null' significa que no ha caducado
);

INSERT INTO dim_customer (cc_num, first_name, last_name, gender, street, city, state, zip, city_pop, job, dob)
SELECT DISTINCT 
    cc_num, first_name, last_name, gender, street, city, state, zip, city_pop, job, dob
FROM raw_transactions;


-- 983 clientes unicos y actuales --
-- SELECT * FROM dim_customer;







-- TABLA DE HECHOS --

CREATE TABLE fct_transactions (
    trans_num TEXT PRIMARY KEY, -- Mantenemos tu diseño original
    customer_sk BIGINT REFERENCES dim_customer(customer_sk),
    merchant_sk INT REFERENCES dim_merchant(merchant_sk),
    date_sk INT REFERENCES dim_date(date_sk),
    hour_sk SMALLINT REFERENCES dim_hour(hour_sk),
    amt NUMERIC(10,2),
    is_fraud SMALLINT
);

INSERT INTO fct_transactions (trans_num, customer_sk, merchant_sk, date_sk, hour_sk, amt, is_fraud)
SELECT 
    r.trans_num,
    c.customer_sk,
    m.merchant_sk,
    CAST(TO_CHAR(r.trans_date_trans_time, 'YYYYMMDD') AS INTEGER),
    EXTRACT(HOUR FROM r.trans_date_trans_time),
    r.amt,
    r.is_fraud
FROM raw_transactions r
JOIN dim_customer c ON r.cc_num = c.cc_num AND c.is_current = TRUE
JOIN dim_merchant m ON REPLACE(r.merchant, 'fraud_', '') = m.merchant_name;

/* SELECT COUNT(*) FROM fct_transactions 
   SELECT COUNT(*) FROM raw_transactions;
   1296675 de registros en ambas tablas, coinciden.
*/


-- PERFORMANCE: creacion de incices para acelerar las consultas

-- Acelera JOINS con dimensiones
CREATE INDEX IF NOT EXISTS idx_fct_customer_sk ON fct_transactions(customer_sk);
CREATE INDEX IF NOT EXISTS idx_fct_merchant_sk ON fct_transactions(merchant_sk);
CREATE INDEX idx_fct_date_sk ON fct_transactions(date_sk);
CREATE INDEX idx_fct_hour_sk ON fct_transactions(hour_sk);
-- Este índice es minúsculo y hace que las queries de "solo fraude" sean instantáneas
CREATE INDEX IF NOT EXISTS idx_fct_only_fraud ON fct_transactions(is_fraud) 
WHERE is_fraud = 1;
-- Para queries tipo: SUM(amt) GROUP BY date_sk WHERE is_fraud = 1
CREATE INDEX IF NOT EXISTS idx_fct_date_fraud ON fct_transactions(date_sk, is_fraud);



