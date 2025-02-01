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
file_name = 'clientes.csv'
csv_file_path = os.path.join(proyecto_final_path, 'datasets', file_name)

def main():

    conn = None
    cursor = None

    try: 
        # Conectar a la base de datos
        conn, cursor = conectar_base()

        if conn:

            # Transformaremos algunos datos antes de cargar.
            df_clientes = pd.read_csv(csv_file_path, sep = ',')

            df_clientes['RazonSocial'] = df_clientes['RazonSocial'].str.title()
            df_clientes['RazonSocial'] = df_clientes['RazonSocial'].str.replace('Acme', 'ACME', regex=False)

            df_clientes['CP'] = pd.to_numeric(df_clientes['CP'], errors='coerce')  # Convierte a numérico, NaN si falla
            df_clientes['CP'] = df_clientes['CP'].fillna(1).astype(int)  # Reemplaza NaN con 1 y convierte a entero
            df_clientes['Telefono'] = pd.to_numeric(df_clientes['Telefono'], errors='coerce') 
            df_clientes['Telefono'] = df_clientes['Telefono'].fillna(1).astype(int)
            df_clientes['Mail'] = df_clientes['Mail'].fillna('NaMail')

            for index, cliente in df_clientes[['RazonSocial', 'Localidad']].iterrows(): 
                if pd.isna(cliente['RazonSocial']):
                    df_clientes.at[index, 'RazonSocial'] = 'NaRS' # No a RazonSocial

                elif pd.isna(cliente['Localidad']):
                    df_clientes.at[index, 'Localidad'] = 'NaL' # No a Location

            df_clientes.drop_duplicates(subset='RazonSocial', keep='first', inplace=True)   # Mantenemos el primer cliente, considerando que 
                                                                                            # no se repite Razon Social.

            # Convertir CSV en un objeto StringIO.
            clientes = io.StringIO()
            df_clientes.to_csv(clientes, index=False)
            clientes.seek(0)

            # Truncar la tabla Stg_Dim_Cliente.
            tabla = 'Stg_Dim_Cliente'
            cursor.execute(f'TRUNCATE TABLE {tabla}')
            print(f'Tabla {tabla} truncada.')

            # Leemos el CSV.
            csv_reader = csv.reader(clientes)
            header = next(csv_reader) # Saltar el encabezado.
            for line in csv_reader:
                    cursor.execute('''
                        INSERT INTO Stg_Dim_Cliente (CodigoCliente, RazonSocial, Telefono, Mail, Direccion, Localidad, Provincia, CP)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                                ''', line)
            print(f'Datos insertados en tabla {tabla}.')
                
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

    