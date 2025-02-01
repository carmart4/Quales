import os
import io
import sys
import csv
import pandas as pd

# Directorio actual STG.
script_path = os.path.dirname(__file__)

# Directorio fase1.
fase1_path = os.path.abspath(os.path.join(script_path, '..'))  # Sube un nivel

# Directorio Python_Scripts.
python_scripts_path = os.path.abspath(os.path.join(fase1_path, '..'))  # Sube un nivel
sys.path.append(python_scripts_path)
from funciones import * # Importamos las funciones para conectar y desconectar la base de datos

# Directorio Proyecto_final.
proyecto_final_path = os.path.abspath(os.path.join(python_scripts_path, '..'))  # Sube un nivel

# Contruir la ruta completa del archivo CSV.
file_name = 'proveedores.csv'
csv_file_path = os.path.join(proyecto_final_path, 'datasets', file_name)

def main():

    conn = None
    cursor = None

    try: 
        # Conectar a la base de datos
        conn, cursor = conectar_base()

        if conn:

            # Trunca la tabla Stg_Dim_Proveedor
            tabla = 'Stg_Dim_Proveedor'
            cursor.execute(f'TRUNCATE TABLE {tabla}')
            print(f'Tabla {tabla} truncada.')

            with open(csv_file_path, mode= 'r', encoding= 'utf-8') as file:
                csv_reader = csv.reader(file)
                header = next(csv_reader) # Saltar el encabezado

                for line in csv_reader:
                    cursor.execute('''
                        INSERT INTO Stg_Dim_Proveedor (CodigoProveedor, NombreProveedor, CostoEstimado)
                        VALUES (?, ?, ?)
                                ''', line)
            
    except Exception as e:
        print(f"Error en la función principal: {e}")

    finally:

        if conn and cursor:
            if desconectar_base(conn, cursor):
                print('Base de datos desconectada correctamente.')
            else:
                print('Error al desconectar la base de datos.') 

if __name__ == '__main__':
    main()