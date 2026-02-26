# Fintech Data Warehouse — Credit Card Fraud Analysis

Data Warehouse implementado en **PostgreSQL** siguiendo la metodología **Kimball** para analizar **1.3M** de transacciones de tarjetas y habilitar análisis de series de tiempo y detección de anomalías/fraude.

- **Volumen:** 1,296,675 transacciones  
- **Enfoque:** Star Schema (OLAP-friendly) + trazabilidad histórica (SCD2)  
- **Stack:** PostgreSQL + Docker + Docker Compose  

---

## Modelo Dimensional (Kimball)

El DW separa entidades de negocio en **dimensiones** y consolida métricas en una **tabla de hechos**, mejorando performance analítica e integridad.

### Fact Table
- **`fct_transactions`**  
  **Grano:** 1 fila = 1 transacción (transacción individual)

### Dimensions
- **`dim_customer`** — *SCD Type 2* (histórico de cambios)
- **`dim_merchant`** — deduplicada / normalizada (merchant único)
- **`dim_date`** — data-driven (generada según el rango real del dataset)
- **`dim_hour`** — dimensión horaria para análisis intradía

---

## 🧠 Decisiones de Ingeniería de Datos

### 1) Trazabilidad histórica con SCD Type 2 (Customer)
Se implementó **SCD Tipo 2** en `dim_customer` para capturar cambios en atributos (p. ej. dirección/empleo) sin reescribir el pasado.

**Estrategia**
- Flags y vigencia temporal: `is_current`, `start_date`, `end_date`
- Joins a dimensión filtrados por vigencia para evitar fan-out y duplicación de hechos

**Resultado**
- Integridad histórica consistente + consultas reproducibles en el tiempo

---

### 2) Normalización de Comercios (control de inconsistencias)
Durante el profiling se detectó que **7 de 693** comercios “únicos” presentaban **categorías inconsistentes** (mismo merchant_name con atributos distintos), lo que podía generar relaciones 1:N no deseadas en la carga.

**Solución**
- Deduplicación determinística en staging usando `DISTINCT ON (merchant_name)` para forzar relación **1:1**
- Prevención de “registros fantasma” en la fact table y mejora de la integridad referencial

---

### 3) Optimización física: Surrogate Keys
Se utilizaron **llaves subrogadas enteras** (SK) para dims y fact.

**Insight**
- Los índices basados en enteros redujeron el tamaño relativo (~2.7% vs llaves textuales), favoreciendo el uso de **Buffer Cache** en Postgres (entorno con **32GB RAM**) y mejorando eficiencia de joins analíticos.

---

## Setup

### 1) Dataset
Descargar desde Kaggle y ubicar el CSV en `./data/`:

- Fuente: https://www.kaggle.com/datasets/priyamchoksi/credit-card-transactions-dataset

### 2) Levantar PostgreSQL con Docker
```bash
docker-compose up -d