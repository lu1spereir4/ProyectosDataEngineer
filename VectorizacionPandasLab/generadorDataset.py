import pandas as pd
import numpy as np
import timeit

print("Generando dataset de 1,000,000 de filas...")
n = 1_000_000
df = pd.DataFrame({
    'lat1': np.random.uniform(-90, 90, n),
    'lon1': np.random.uniform(-180, 180, n),
    'lat2': np.random.uniform(-90, 90, n),
    'lon2': np.random.uniform(-180, 180, n)
})

# Función de apoyo para el cálculo (Distancia Euclidiana simple)
def haversine_python(lat1, lon1, lat2, lon2):
    return ((lat2 - lat1)**2 + (lon2 - lon1)**2)**0.5

print("Dataset listo. Comienza el benchmark.\n")