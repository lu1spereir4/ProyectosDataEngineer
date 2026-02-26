💳 Fintech Data Warehouse: Credit Card Transactions Analysis
Este proyecto implementa un Data Warehouse robusto utilizando un modelo de estrella (Kimball Star Schema) para analizar un dataset de 1.3M de transacciones de tarjetas de crédito. El objetivo es optimizar la detección de fraude y el análisis de series de tiempo.

🏗️ Arquitectura del Modelo
El modelo sigue la metodología de Ralph Kimball, optimizando el rendimiento de las consultas analíticas mediante la separación de hechos y dimensiones.

Fact Table: fct_transactions (Granularidad: Transacción individual).

Dimensions: dim_customer, dim_merchant, dim_date, dim_hour.

🛠️ Decisiones de Ingeniería de Datos
1. Implementación de SCD Tipo 2 (Slowly Changing Dimensions)
Para la dimensión de clientes (dim_customer), se optó por una estrategia de SCD Tipo 2.

Razón: Los atributos de los usuarios (dirección, trabajo, población de la ciudad) pueden cambiar con el tiempo. Para no perder la trazabilidad histórica de las transacciones bajo el contexto original, se añadieron las columnas is_current, start_date y end_date.

Integridad: Durante la carga de la tabla de hechos, se utiliza el filtro is_current = TRUE para evitar la duplicación de transacciones (fan-out) al realizar los joins.

2. Normalización y Manejo de Duplicados (Dimensión Merchant)
Durante el perfilamiento de datos (Data Profiling), se identificó que el dataset original presentaba una relación Muchos a Muchos (M:N) implícita entre nombres de comercios y categorías/ubicaciones.

Problema: Un mismo comercio aparecía con múltiples categorías o coordenadas ligeramente distintas, lo que generaba duplicados en la dimensión y, por consecuencia, en la tabla de hechos.

Solución: Se aplicó una técnica de Data Cleansing utilizando la cláusula DISTINCT ON (merchant_name) de PostgreSQL. Esto garantiza una relación 1:1 entre el nombre del comercio y su ID único (merchant_sk), eliminando el ruido de los atributos inconsistentes y asegurando la integridad referencial del modelo.

🚀 Stack Tecnológico
Base de Datos: PostgreSQL (Engine).

Infraestructura: Docker & Docker-Compose para despliegue de base de datos y pgAdmin.

Volumen de Datos: 1,296,675 registros procesados.

📥 Ingestión de Datos
El archivo fuente credit_card_transactions.csv está excluido del repositorio debido a su tamaño (~350MB).

Descargue el dataset desde .

Ubique el archivo en la carpeta /data/.

Ejecute docker-compose up -d para levantar el entorno e inicie los scripts SQL en el orden numérico establecido.