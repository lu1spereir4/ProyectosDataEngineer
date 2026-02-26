💳 Fintech Data Warehouse: Credit Card Fraud Analysis
Este proyecto implementa un Data Warehouse basado en la metodología de Kimball para procesar 1.3M de transacciones. Se diseñó un modelo de estrella optimizado en PostgreSQL para análisis de series de tiempo y detección de anomalías.

🏗️ Arquitectura del Modelo
El sistema separa las entidades de negocio en dimensiones para garantizar integridad y rapidez.

Fact Table: fct_transactions (Granularidad: Transacción individual).

Dimensions: dim_customer (SCD Type 2), dim_merchant (Deduplicada), dim_date (Data-Driven), dim_hour.

🛠️ Decisiones de Ingeniería de Datos

1. Trazabilidad Histórica (SCD Tipo 2)
Se implementó SCD Tipo 2 en la dimensión de clientes para capturar cambios en atributos como dirección o empleo sin alterar el pasado.

Estrategia: Uso de flags is_current y ventanas temporales (start_date, end_date).

Integridad: Se filtran joins por vigencia para evitar la duplicación de hechos (fan-out).

2. Normalización de Comercios (Handling M:N)
Se detectó que 7 de los 693 comercios únicos presentaban categorías inconsistentes.

Solución: Se aplicó DISTINCT ON (merchant_name) en la etapa de carga para forzar una relación 1:1. Esto evitó la creación de registros fantasma en la tabla de hechos y garantizó la integridad referencial.

3. Benchmarks de Performance
Se validó la eficiencia del modelo comparando el almacenamiento de índices contra una tabla plana (raw):
| Índice | Tipo de Dato | Tamaño Físico |
| :--- | :--- | :--- |
| idx_fct_merchant_sk | INTEGER | 9,064 kB |
| idx_raw_merchant_clean | TEXT | 9,312 kB |

Insight: El uso de llaves subrogadas enteras redujo el tamaño del índice en un 2.7%, optimizando el uso de la Buffer Cache de Postgres para los 32GB de RAM disponibles.

🚀 Setup & Stack
Stack: PostgreSQL, Docker, Docker-Compose.

Volumen: 1,296,675 registros.

Setup:

Ubicar dataset en /data/ , descargar de https://www.kaggle.com/datasets/priyamchoksi/credit-card-transactions-dataset y extraer el csv

docker-compose up -d.

Ejecutar scripts en orden: 01_init_landing.sql, 02_model_star_schema.sql, queries_finales.sql.