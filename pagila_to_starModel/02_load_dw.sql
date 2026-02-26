-- =========================
-- DIM DATE (desde payment_date)
-- =========================
INSERT INTO dw.dim_date (date_sk, date, year, month, day, day_of_week, week_of_year, quarter)
SELECT
  (EXTRACT(YEAR FROM d)::int * 10000
   + EXTRACT(MONTH FROM d)::int * 100
   + EXTRACT(DAY FROM d)::int) AS date_sk,
  d::date AS date,
  EXTRACT(YEAR FROM d)::smallint AS year,
  EXTRACT(MONTH FROM d)::smallint AS month,
  EXTRACT(DAY FROM d)::smallint AS day,
  EXTRACT(ISODOW FROM d)::smallint AS day_of_week,
  EXTRACT(WEEK FROM d)::smallint AS week_of_year,
  EXTRACT(QUARTER FROM d)::smallint AS quarter
FROM generate_series(
  (SELECT MIN(payment_date)::date FROM payment),
  (SELECT MAX(payment_date)::date FROM payment),
  interval '1 day'
) AS gs(d)
ON CONFLICT (date) DO NOTHING;

-- =========================
-- DIM CUSTOMER
-- =========================
INSERT INTO dw.dim_customer (
  customer_id, first_name, last_name, email, active, create_date,
  address, district, city, country, postal_code
)
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  c.email,
  c.activebool,
  c.create_date,
  a.address,
  a.district,
  ci.city,
  co.country,
  a.postal_code
FROM customer c
JOIN address a  ON a.address_id = c.address_id
JOIN city ci    ON ci.city_id = a.city_id
JOIN country co ON co.country_id = ci.country_id
ON CONFLICT (customer_id) DO NOTHING;

-- =========================
-- DIM STAFF
-- =========================
INSERT INTO dw.dim_staff (staff_id, first_name, last_name, email, active, store_id)
SELECT
  s.staff_id,
  s.first_name,
  s.last_name,
  s.email,
  s.active,
  s.store_id
FROM staff s
ON CONFLICT (staff_id) DO NOTHING;

-- =========================
-- DIM STORE
-- =========================
INSERT INTO dw.dim_store (store_id, manager_staff_id, address, district, city, country, postal_code)
SELECT
  st.store_id,
  st.manager_staff_id,
  a.address,
  a.district,
  ci.city,
  co.country,
  a.postal_code
FROM store st
JOIN address a  ON a.address_id = st.address_id
JOIN city ci    ON ci.city_id = a.city_id
JOIN country co ON co.country_id = ci.country_id
ON CONFLICT (store_id) DO NOTHING;

-- =========================
-- DIM FILM con categoría principal (MIN)
-- =========================
WITH primary_cat AS (
  SELECT
    fc.film_id,
    MIN(c.name) AS primary_category
  FROM film_category fc
  JOIN category c ON c.category_id = fc.category_id
  GROUP BY fc.film_id
)
INSERT INTO dw.dim_film (
  film_id, title, language, release_year, rental_duration, rental_rate, length, rating, primary_category
)
SELECT
  f.film_id,
  f.title,
  l.name AS language,
  f.release_year,
  f.rental_duration,
  f.rental_rate,
  f.length,
  f.rating::text,
  pc.primary_category
FROM film f
JOIN language l ON l.language_id = f.language_id
LEFT JOIN primary_cat pc ON pc.film_id = f.film_id
ON CONFLICT (film_id) DO NOTHING;

-- =========================
-- FACT PAYMENTS (grano: payment)
-- Join path: payment -> rental -> inventory -> film (+ store)
-- =========================
INSERT INTO dw.fct_payments (
  payment_id, date_sk, customer_sk, staff_sk, store_sk, film_sk, rental_id, amount
)
SELECT
  p.payment_id,
  (EXTRACT(YEAR FROM p.payment_date)::int * 10000
   + EXTRACT(MONTH FROM p.payment_date)::int * 100
   + EXTRACT(DAY FROM p.payment_date)::int) AS date_sk,
  dc.customer_sk,
  ds.staff_sk,
  dstore.store_sk,
  df.film_sk,
  p.rental_id,
  p.amount
FROM payment p
JOIN rental r     ON r.rental_id = p.rental_id
JOIN inventory i  ON i.inventory_id = r.inventory_id
JOIN dw.dim_customer dc ON dc.customer_id = p.customer_id
JOIN dw.dim_staff ds    ON ds.staff_id = p.staff_id
JOIN dw.dim_store dstore ON dstore.store_id = i.store_id
JOIN dw.dim_film df     ON df.film_id = i.film_id
ON CONFLICT (payment_id) DO NOTHING;