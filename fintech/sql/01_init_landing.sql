CREATE TABLE raw_transactions (
    unnamed_0 INT,
    trans_date_trans_time TIMESTAMP,
    cc_num BIGINT,
    merchant TEXT,
    category TEXT,
    amt DECIMAL(10,2),
    first_name TEXT,
    last_name TEXT,
    gender CHAR(1),
    street TEXT,
    city TEXT,
    state TEXT,
    zip INT,
    lat DECIMAL(10,6),
    long DECIMAL(10,6),
    city_pop INT,
    job TEXT,
    dob DATE,
    trans_num TEXT,
    unix_time BIGINT,
    merch_lat DECIMAL(10,6),
    merch_long DECIMAL(10,6),
    is_fraud INT,
    merch_zipcode DECIMAL(10,1)
);

COPY raw_transactions 
FROM '/var/lib/postgresql/data_csv/credit_card_transactions.csv' 
DELIMITER ',' 
CSV HEADER 
QUOTE '"' 
ESCAPE '"';