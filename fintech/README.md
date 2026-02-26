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

Insight: El uso de llaves subrogadas enteras redujo el tamaño del índice en un 2.7%, optimizando el uso de la Buffer Cache de Postgres para los 32GB de RAM disponibles.

🚀 Setup & Stack
Stack: PostgreSQL, Docker, Docker-Compose.

Volumen: 1,296,675 registros.

Setup:

Ubicar dataset en /data/ , descargar de https://www.kaggle.com/datasets/priyamchoksi/credit-card-transactions-dataset y extraer el csv

docker-compose up -d.

Ejecutar scripts en orden: 01_init_landing.sql, 02_model_star_schema.sql, queries_finales.sql.

Esta es una excelente forma de cerrar la documentación de tu proyecto. Como Ingeniero, no solo estás entregando código, sino que estás aportando un análisis crítico sobre la arquitectura y la eficiencia física de los datos.

Aquí tienes una versión redactada con un tono más profesional y técnico para tu README.md, incorporando tus hallazgos sobre los índices y las reflexiones sobre el Modern Data Stack.

🏁 Conclusiones y Próximos Pasos

Rendimiento y Modelado
Tras procesar 1.3M de registros, se observó que PostgreSQL mantiene un rendimiento excepcional tanto en estructuras desnormalizadas (tablas planas) como en el Star Schema propuesto. Si bien las diferencias en los tiempos de respuesta para este volumen de datos se midieron en centésimas de segundo, el modelo de estrella demostró una superioridad estructural clara:

Eficiencia de Almacenamiento: Los índices sobre Surrogate Keys (enteros) resultaron físicamente más ligeros y densos que los índices sobre columnas de texto en la tabla raw, optimizando el uso de la memoria RAM.

Escalabilidad: El modelado dimensional facilita la mantenibilidad y la integridad histórica mediante SCD Tipo 2, evitando la redundancia masiva de datos.

Reflexión Técnica: ¿PostgreSQL o DuckDB?
El cierre de este proyecto abre la puerta a nuevas interrogantes sobre la evolución de las herramientas analíticas:

DuckDB + Parquet: Representan el siguiente paso para cargas de trabajo puramente OLAP. Aunque su velocidad de agregación es superior gracias al almacenamiento columnar, surge el desafío del manejo de SCD Tipo 2.

Actualizaciones (SCD): PostgreSQL destaca por su manejo nativo de nulos, fechas de cierre y concurrencia. En contraste, el formato Parquet no está diseñado para actualizaciones de filas individuales, lo que requeriría estrategias de "overwrite" o el uso de tablas Delta.

Roadmap Futuro
Escalabilidad: Migrar las pruebas a datasets de mayor envergadura (>10M de filas) para estresar la arquitectura.

Optimización Profunda: Profundizar en el uso de EXPLAIN ANALYZE para identificar cuellos de botella en planes de ejecución complejos.

Stack Híbrido: Experimentar con DuckDB como motor de consulta sobre los archivos exportados desde el Star Schema de PostgreSQL.