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
file_name = 'tiendas.csv'
csv_file_path = os.path.join(proyecto_final_path, 'datasets', file_name)

def main():

    conn = None
    cursor = None

    try: 
        # Conectar a la base de datos
        conn, cursor = conectar_base()

        if conn:

            # Transformaremos algunos datos antes de cargar.
            df_tiendas = pd.read_csv(csv_file_path, sep = '[,;]', engine='python')

            df_tiendas.drop_duplicates(subset='Descripcion', keep='first', inplace=True)
            df_tiendas.drop([14], axis=0, inplace=True) # Error en la generación de datos, porque repite el titulo del df. 

            for index, tienda in df_tiendas.iterrows():
                if (tienda['TipoTienda'] == 'Online'):
                    df_tiendas.at[index, 'CP'] = '0'
                    df_tiendas.loc[index, df_tiendas.columns[2:5]] = 'Virtual'

                elif (not pd.isna(tienda['Direccion']) or not pd.isna(tienda['Localidad'])) and (tienda['Provincia'] != 'Virtual'):
                    df_tiendas.loc[index, 'TipoTienda'] = 'Sucursal'

            # Debo iterar nuevamente para no interrumpir la operación lógica de la anterior iteración. 
            for index, tienda in df_tiendas[['Descripcion', 'Direccion', 'Localidad']].iterrows():                
                if pd.isna(tienda['Descripcion']):
                    df_tiendas.at[index, 'Descripcion'] = 'NaDes' # No a Description
                
                elif pd.isna(tienda['Direccion']):
                    df_tiendas.at[index, 'Direccion'] = 'NaDir' # No a Direction

                elif pd.isna(tienda['Localidad']):
                    df_tiendas.at[index, 'Localidad'] = 'NaL' # No a Location
            
            df_tiendas['CP'] = df_tiendas['CP'].fillna(1).astype(int)
                    
            # Convertit a CSV en un objeto StringIO.
            tiendas = io.StringIO()
            df_tiendas.to_csv(tiendas, index=False)
            tiendas.seek(0)     

            # Truncar la tabla Stg_Dim_Tienda.
            tabla = 'Stg_Dim_Tienda'
            cursor.execute(f'TRUNCATE TABLE {tabla}')
            print(f'Tabla {tabla} truncada.')

            # Leemos el CSV.
            csv_reader = csv.reader(tiendas)
            header = next(csv_reader) # Saltar el encabezado.
            for line in csv_reader:
                    cursor.execute('''
                        INSERT INTO Stg_Dim_Tienda (CodigoTienda, Descripcion, Direccion, Localidad, Provincia, CP, TipoTienda)
                        VALUES (?, ?, ?, ?, ?, ?, ?)
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
            