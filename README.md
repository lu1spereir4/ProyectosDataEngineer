# 🧠 Data Engineering Portfolio — Modern Stack Specialist (Chile 🇨🇱)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.10%2B-blue)](https://www.python.org/)
[![AWS](https://img.shields.io/badge/AWS-Infrastructure-orange)](https://aws.amazon.com/)
[![English](https://img.shields.io/badge/English-C1%20Advanced-green)](https://www.cambridgeenglish.org/)

Bienvenido a mi repositorio de proyectos de Ingeniería de Datos. Soy **Ingeniero Civil en Informática** enfocado en construir infraestructuras de datos escalables, seguras y altamente eficientes. Este portafolio es el resultado de un **roadmap intensivo de 3 meses** diseñado para dominar el procesamiento distribuido, modelado dimensional y orquestación en la nube.

> **Objetivo:** Transformar datos crudos en activos estratégicos mediante arquitectura de software sólida y optimización de rendimiento.

---

## 🛠️ Stack Tecnológico & Skills

| Categoría | Tecnologías |
| :--- | :--- |
| **Lenguajes** | Python (Boto3, Polars, Pandas), SQL (PostgreSQL, DuckDB) |
| **Infraestructura Cloud** | AWS (S3, RDS, IAM, Lambda, Glue Basics) |
| **Procesamiento** | PySpark (Distributed Computing), dbt (Analytics Engineering) |
| **Orquestación** | Docker, Docker Compose, Apache Airflow |
| **Modelado** | Kimball (Star Schema), SCD Type 2, Data Contracts |

---

## 🏗️ Proyectos Destacados

### 1. 💳 Fintech Data Warehouse — Credit Card Fraud Analytics
**Core:** *PostgreSQL | Kimball | SQL Avanzado*
Diseño y construcción de un Data Warehouse para procesar **1.3M de transacciones**. Implementé un modelo estrella optimizado para detectar anomalías financieras.
* **Highlights:** Implementación de **SCD Tipo 2** para `dim_customer`, optimización de queries mediante `EXPLAIN ANALYZE` y uso de **Window Functions** para análisis de series temporales.
* [Ver Proyecto](./fintech) | [Documentación Técnica](./fintech/README.md)


### 3. 🎬 Pagila DW — OLTP to Star Schema
**Core:** *SQL | Dimensional Modeling*
Migración de una base de datos relacional compleja (Pagila) a un modelo dimensional, comparando el rendimiento y la legibilidad de las consultas analíticas.
* **Highlights:** Uso de **Degenerate Dimensions** y creación de reportes OLAP complejos con `CUBE` y `ROLLUP`.
* [Ver Proyecto](./pagila)

---

## 📈 Roadmap de Ejecución (8 Semanas)

Este portafolio sigue un régimen de alto rendimiento (14-16 pomodoros diarios):

1.  **Semana 1-2:** SQL Deep Dive (Window Functions, Optimización) y Pythonic DE (Eficiencia de memoria).
2.  **Semana 3-4:** Cloud Foundations (AWS Security & S3) y Analytics Engineering con **dbt**.
3.  **Semana 5-6:** Big Data con **PySpark** y Orquestación con **Docker/Airflow**.
4.  **Semana 7-8:** Proyecto End-to-End y preparación para entrevistas técnicas (System Design).

---

## 🚀 Cómo ejecutar estos proyectos

Cada proyecto está **dockerizado**. Para replicar cualquiera de los entornos:

```bash
git clone [https://github.com/tu-usuario/data-engineering-portfolio.git](https://github.com/tu-usuario/data-engineering-portfolio.git)
cd <nombre-del-proyecto>
docker-compose up -d
