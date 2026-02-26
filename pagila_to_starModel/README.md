# 🎬 Pagila Data Warehouse — OLTP vs Star Schema Analytics

Este proyecto toma la base de datos **Pagila (PostgreSQL sample)** y construye un **Data Warehouse en modelo estrella** para análisis de ventas/alquileres, comparando consultas entre el **OLTP normalizado** y el **DW desnormalizado**.

El objetivo es práctico: **entender por qué un Star Schema simplifica el análisis**, reduce la complejidad de JOINs y estandariza el acceso a métricas.

---

## 🧱 Modelo Dimensional (Star Schema)

Se diseñó un modelo estrella simple orientado a reporting y agregaciones.

### Fact Table
- **`fct_rentals` / `fct_payments`** *(según tu implementación)*
  - **Grano:** 1 fila por evento de negocio (alquiler / pago).
  - **Métricas típicas:** monto, cantidad de transacciones, duración, etc.

### Dimensions (ejemplos típicos)
- **`dim_date`** (calendario para análisis temporal)
- **`dim_customer`**
- **`dim_film`**
- **`dim_store`**
- **`dim_staff`**
- **`dim_inventory` / `dim_category`** *(según el alcance que elegiste)*

> Nota: en este DW **no se implementa SCD Type 2**, porque el objetivo principal fue dominar el patrón estrella y el flujo de carga.

---

## 🧾 Atributo Degenerado (Degenerate Dimension)

En la tabla de hechos se conserva el identificador operacional:

- **`rental_id`** como **atributo degenerado** (no vive en una dimensión propia)

**¿Por qué sirve?**
- Permite trazabilidad hacia el OLTP sin crear una dimensión artificial.
- Es útil para auditoría, drill-through y debugging.
- Mantiene el grano intacto y evita más joins de los necesarios.

---

## 🔍 Aprendizajes Clave: OLTP vs DW

Se realizaron consultas tanto en:
- **Pagila OLTP** (modelo altamente normalizado)
- **Pagila DW** (modelo estrella)

**Conclusión técnica**
- En OLTP, para responder preguntas analíticas comunes se requieren **muchos JOINs** (tablas puente, normalización por diseño, etc.).
- En Star Schema, las consultas se vuelven **más cortas, más legibles** y con menos riesgo de errores (fan-out, duplicaciones, joins mal filtrados).

**Resultado**
- El Star Schema es mejor opción para BI/analytics cuando tu prioridad es:
  - **simplicidad de consulta**
  - **consistencia de métricas**
  - **performance en agregaciones**
  - **mantenibilidad del reporting**


### Estructura del proyecto
- `01_dw_schema.sql` → crea el esquema DW (dims + facts)
- `02_load_dw.sql` → carga / transformación desde OLTP a DW
- `03_queries_pagila_core.sql` → queries de práctica (OLTP vs DW)
- Diagramas: `pagila-schema-diagram.png`, `star_model.png`

