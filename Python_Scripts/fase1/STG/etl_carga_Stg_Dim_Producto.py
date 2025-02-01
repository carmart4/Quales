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
file_name = 'productos.csv'
csv_file_path = os.path.join(proyecto_final_path, 'datasets', file_name)

def main():

    conn = None
    cursor = None

    try: 
        # Conectar a la base de datos
        conn, cursor = conectar_base()

        if conn:

            # Transformaremos algunos datos antes de cargar.
            df_productos = pd.read_csv(csv_file_path, sep = '[,;]', engine='python') # Parámetro engine='python' por la cantidad de separadores.
            
            df_productos['Descripcion'] = df_productos['Descripcion'].str.strip('"') # Quitamos los caracteres '"'. 
            
            vocal_con, vocal_sin = 'áéíóúü','aeiouu' # Para cada elemento de la categoría dejamos las vocales sin tílde.
            vocal = str.maketrans(vocal_con, vocal_sin)
            col = df_productos['Categoria']
            for index, categoria in enumerate(col):
                if type(categoria) == str:
                    print(categoria)
                    categoria = categoria.translate(vocal)
                    col[index] = categoria

            df_productos['Descripcion'] = df_productos['Descripcion'].str.capitalize()
            df_productos['Descripcion'] = df_productos['Descripcion'].str.replace('led', 'LED', regex=False)     

            df_productos_nulos = df_productos[df_productos.isnull().any(axis=1)].reset_index(drop=True) # Verificamos productos con valores nulos.
            df_productos = df_productos.dropna(axis=0).reset_index(drop=True)

            total = 0
            suma_diferencia = 0
            for i in range(len(df_productos_nulos)):
                dif = df_productos['PrecioVentaSugerido'][i] / df_productos['PrecioCosto'][i]
                total += 1
                suma_diferencia += dif
            dif_porcental = suma_diferencia/total # Diferencia media que hay entre precio costo y precio venta sugerido, para completar nulos.

            for index, precio in df_productos_nulos[['PrecioCosto', 'PrecioVentaSugerido']].iterrows():
                if pd.isna(precio['PrecioCosto']):
                    if not pd.isna(df_productos_nulos.loc[index, 'PrecioVentaSugerido']):  # Comprobar si 'PrecioVentaSugerido' no es NaN
                        PrecioVentaSugerido = float(df_productos_nulos.loc[index, 'PrecioVentaSugerido'])
                        df_productos_nulos.at[index, 'PrecioCosto'] = (PrecioVentaSugerido / dif_porcental)
                
                elif pd.isna(precio['PrecioVentaSugerido']):
                    if not pd.isna(df_productos_nulos.loc[index, 'PrecioCosto']):  # Comprobar si 'PrecioCosto' no es NaN
                        PrecioCosto = float(df_productos_nulos.loc[index, 'PrecioCosto'])
                        df_productos_nulos.at[index, 'PrecioVentaSugerido'] = (PrecioCosto * dif_porcental)

            df_productos_nulos.loc[df_productos_nulos['Descripcion'].str.contains('Refrigerador', na=False), 'Categoria'] = 'Electrodomesticos'
            df_productos_nulos[['PrecioCosto', 'PrecioVentaSugerido']] = round(df_productos_nulos[['PrecioCosto', 'PrecioVentaSugerido']], 1)       

            df_productos = pd.concat([df_productos, df_productos_nulos]).reset_index(drop=True)

            df_productos['Marca'] = df_productos['Marca'].fillna('NaM') # No a Marca

            # Convertit a CSV en un objeto StringIO.
            productos = io.StringIO()
            df_productos.to_csv(productos, index=False)
            productos.seek(0)

            # Truncar la tabla Stg_Dim_Producto.
            tabla = 'Stg_Dim_Producto'
            cursor.execute(f'TRUNCATE TABLE {tabla}')
            print(f'Tabla {tabla} truncada.')

            # Leemos el CSV.
            csv_reader = csv.reader(productos)
            header = next(csv_reader) # Saltar el encabezado.
            for line in csv_reader:
                    cursor.execute('''
                        INSERT INTO Stg_Dim_Producto (CodigoProducto, Descripcion, Categoria, Marca, PrecioCosto, PrecioVentaSugerido)
                        VALUES (?, ?, ?, ?, ?, ?)
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