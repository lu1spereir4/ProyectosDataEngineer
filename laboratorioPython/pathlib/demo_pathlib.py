from pathlib import Path

proyect_root = Path(__file__).resolve().parents[0] # Obtenemos la ruta del directorio del proyecto
#print(proyect_root)
#if not (proyect_root / "lake" / "raw").exists():
#    (proyect_root / "lake" / "raw").mkdir(parents=True) # Creamos la carpeta si no existe

# no hace falta el if para verificar si existe la carpeta, ya que mkdir con parents=True y exist_ok=True se encarga de eso
raw_zone = proyect_root / "lake" / "raw"
raw_zone.mkdir(parents=True, exist_ok=True) # Creamos la carpeta si no existe

raw_zone.glob("*.csv") # Listamos los archivos CSV en la carpeta raw
for archivo in raw_zone.glob("*.csv"):
    print(archivo.name) # Imprimimos el nombre de cada archivo CSV encontrado

raw_zone.glob("*.csv") # Listamos los archivos CSV en la carpeta raw y sus subcarpetas
for archivo in raw_zone.glob("**/*.csv"):
    print(archivo.name) # Imprimimos el nombre de cada archivo CSV encontrado



# Extraer la fecha

for archivo in raw_zone.glob("*.csv"):
    nombre = archivo.stem # Obtenemos el nombre del archivo sin la extensión
    partes = nombre.split("_") # Dividimos el nombre por guiones bajos
    fecha_str = partes[3] # La fecha está en la cuarta parte (índice 3)
    print(f"Archivo: {archivo.name} - Fecha extraída: {fecha_str}")


# Particionamiento hive

for archivo in raw_zone.glob("**/*.csv"):
    nombre = archivo.stem # Obtenemos el nombre del archivo sin la extensión
    partes = nombre.split("_") # Dividimos el nombre por guiones bajos
    try:
        fecha_str = partes[3] # La fecha está en la cuarta parte (índice 3)
    except IndexError:
        print(f"Archivo: {archivo.name} - No se pudo extraer la fecha")

        continue    
    # Creamos la ruta de partición basada en la fecha
    particion_path = proyect_root / 'lake' / 'processed' + 'quarentine' / 'viajes' / f"date_cut={fecha_str}"
    
    # Creamos la carpeta de partición si no existe
    particion_path.mkdir(parents=True, exist_ok=True)
    
    # Movemos el archivo a la carpeta de partición
    nuevo_path = particion_path / archivo.name
    archivo.rename(nuevo_path)
    
    print(f"Archivo: {archivo.name} movido a: {nuevo_path}")