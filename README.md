# Data Engineering Portfolio

> **Ingeniero Civil en Informatica** construyendo infraestructura de datos production-ready semana a semana.  
> Nuevos proyectos cada semana mientras avanzo por un roadmap intensivo de 8 semanas.

[![Python](https://img.shields.io/badge/Python-3.10%2B-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![AWS](https://img.shields.io/badge/AWS-FF9900?style=flat&logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![dbt](https://img.shields.io/badge/dbt-FF694B?style=flat&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![Apache Spark](https://img.shields.io/badge/Apache%20Spark-E25A1C?style=flat&logo=apachespark&logoColor=white)](https://spark.apache.org/)
[![Airflow](https://img.shields.io/badge/Airflow-017CEE?style=flat&logo=apacheairflow&logoColor=white)](https://airflow.apache.org/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)

---

## Sobre este repositorio

Este portafolio documenta mi especializacion en **Data Engineering** como Ingeniero Civil en Informatica. Cada proyecto resuelve un problema de datos real, aplicando las herramientas y criterios de diseno que usan equipos de ingenieria en el sector financiero, retail y tecnologia.

**Actualizacion semanal:** subo un nuevo proyecto o iteracion conforme avanzo en el roadmap.

---

## Stack Tecnologico

| Area | Herramientas |
|:--|:--|
| **Lenguajes** | Python, SQL (PostgreSQL, DuckDB) |
| **Modelado** | Star Schema (Kimball), SCD Type 1 & 2, Data Contracts |
| **Transformaciones** | dbt Core, Pandas, Polars, PySpark |
| **Cloud** | AWS S3, RDS, IAM, Lambda |
| **Orquestacion** | Apache Airflow, Docker, Docker Compose |
| **Performance** | EXPLAIN ANALYZE, Indexing, Query Optimization |

---

## Proyectos

### [Fintech — Credit Card Transactions DW](./fintech)
**Stack:** PostgreSQL, Star Schema, Window Functions, SQL avanzado

Data Warehouse sobre **1.3M de transacciones** de tarjetas de credito. Modelo estrella orientado a analisis financiero y deteccion de comportamientos anomalos.

- Rankings por region y categoria, churn a 90 dias y rolling averages con Window Functions
- SCD Tipo 2 en `dim_customer` para tracking historico de cambios
- Optimizacion con `EXPLAIN ANALYZE`: reduccion de tiempo de escaneo mediante indices

---

### [Pagila — OLTP to Star Schema](./pagila_to_starModel)
**Stack:** PostgreSQL, Dimensional Modeling, OLAP

Migracion completa de una base de datos relacional (Pagila) a un modelo dimensional para analisis. Incluye `fct_payments`, `dim_customer`, `dim_film`, `dim_store` y `dim_date`.

- Resolucion de fan traps y relaciones M:N (films <-> categoria)
- 6 queries analiticas: revenue mensual, MoM%, rolling 7 dias, clientes inactivos, ranking de staff
- Validacion de grano con control de FKs nulas

---

## Proyectos en curso

Actualmente estoy profundizando en el stack completo de Data Engineering — SQL avanzado, Python, AWS, dbt, PySpark y orquestacion con Airflow.

Cada semana subo un laboratorio o proyecto nuevo para aplicar los contenidos estudiados sobre datos reales. Los proyectos aqui publicados son el resultado directo de ese proceso.

---

## Como ejecutar los proyectos

Todos los entornos estan dockerizados:

```bash
git clone https://github.com/tu-usuario/ProyectosDataEngineer.git
cd <proyecto>
docker-compose up -d
```

Cada carpeta incluye su propio `README.md` con el esquema de datos, decisiones de diseno y queries relevantes.

---

## Contacto

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Conectar-0A66C2?style=flat&logo=linkedin&logoColor=white)](https://linkedin.com/in/tu-perfil)