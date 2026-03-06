import csv
import random
from pathlib import Path
from datetime import datetime, timedelta

# 1. Definimos la ruta de nuestra zona "cruda" usando pathlib
project_root = Path(__file__).resolve().parent
raw_zone = project_root / "lake" / "raw"

# Creamos la carpeta si no existe
raw_zone.mkdir(parents=True, exist_ok=True)

# 2. Configuración para los datos falsos
rutas_buses = ["506", "210", "401", "B02", "C14"]
fecha_base = datetime(2025, 4, 20)

print(f"Generando archivos CSV en: {raw_zone}...\n")

# 3. Generamos 3 archivos CSV para 3 días distintos
for i in range(3):
    fecha_actual = fecha_base + timedelta(days=i)
    fecha_str = fecha_actual.strftime("%Y-%m-%d")
    
    # El nombre del archivo incluye la fecha de forma "desordenada"
    nombre_archivo = f"export_dtpm_viajes_{fecha_str}_v1.csv"
    ruta_archivo = raw_zone / nombre_archivo
    
    # Escribimos datos dummy en el CSV
    with open(ruta_archivo, mode="w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["id_viaje", "timestamp", "ruta", "validaciones"]) # Cabeceras
        
        # Generamos entre 5 y 10 filas de datos por archivo
        for viaje_id in range(random.randint(5, 10)):
            hora_random = f"{random.randint(6, 22):02d}:{random.randint(0, 59):02d}:00"
            writer.writerow([
                f"V-{fecha_str.replace('-','')}-{viaje_id}", 
                f"{fecha_str} {hora_random}", 
                random.choice(rutas_buses), 
                random.randint(1, 5)
            ])
            
    print(f"✔️ Creado: {ruta_archivo.name} ({ruta_archivo.stat().st_size} bytes)")

print("\n¡Laboratorio listo! Tienes 3 archivos crudos esperando ser procesados.")