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
file_name = 'ventas.csv'
csv_file_path = os.path.join(proyecto_final_path, 'datasets', file_name)

def main():

    conn = None
    cursor = None

    try: 
        # Conectar a la base de datos
        conn, cursor = conectar_base()

        if conn:

            # Transformaremos algunos datos antes de cargar.
            df_ventas = pd.read_csv(csv_file_path, sep = '[,;]', engine='python')

            df_ventas.drop_duplicates(inplace=True)
            df_ventas['CodigoProducto'] = df_ventas['CodigoProducto'].fillna(0).astype(int)
            df_ventas['Cantidad'] = df_ventas['Cantidad'].fillna(0).astype(int)
            df_ventas['CodigoCliente'] = df_ventas['CodigoCliente'].fillna(0).astype(int)
            df_ventas['CodigoTienda'] = df_ventas['CodigoTienda'].fillna(0).astype(int)
            df_ventas['Producto'] = df_ventas['Producto'].str.strip('"')
            df_ventas['Producto'] = df_ventas['Producto'].str.capitalize()
            df_ventas['Producto'] = df_ventas['Producto'].str.replace('led', 'LED', regex=False)

            col_fecha = df_ventas['FechaVenta']
            for fecha in range(len(col_fecha)): # Normalizamos el formato de fecha, dado que habían varios. 
                if type(col_fecha[fecha]) == str:
                    if col_fecha[fecha].startswith(('2024', '2023', '2022')):
                        anio = col_fecha[fecha][:4]
                        mes = int(col_fecha[fecha][5:7])
                        dia = int(col_fecha[fecha][8:])
                        if mes > 12:
                            dia = col_fecha[fecha][5:7]
                            mes = col_fecha[fecha][8:]
                        col_fecha[fecha] = anio+'-'+str(mes)+'-'+str(dia)
                    if not(col_fecha[fecha].startswith(('2024', '2023', '2022'))):
                        anio = col_fecha[fecha][3:7]
                        mes = int(col_fecha[fecha][:2])
                        dia = int(col_fecha[fecha][8:])
                        if mes > 12:
                            dia = col_fecha[fecha][:2]
                            mes = col_fecha[fecha][8:]
                        col_fecha[fecha] = anio+'-'+str(mes)+'-'+str(dia)
            df_ventas.drop_duplicates(inplace=True)

            df_ventas_nulos = df_ventas[df_ventas.isnull().any(axis=1)].reset_index(drop=True)
            df_ventas = df_ventas.dropna(axis=0).reset_index(drop=True)

            # Si Cantidad o Previo venta es menor o igual a cero, la venta no será registrada. Al igual que si ambos valores son nulos. 
            filtro =    (((df_ventas_nulos['Cantidad'].isnull()) & (df_ventas_nulos['PrecioVenta'].isnull())) | 
                        (df_ventas_nulos['Cantidad'] <= 0) | (df_ventas_nulos['PrecioVenta'] <= 0))
            df_ventas_nulos = df_ventas_nulos[~filtro].reset_index(drop=True)
            
            df_ventas = pd.concat([df_ventas, df_ventas_nulos]).reset_index(drop=True)

            filtro2 =   ((df_ventas['CodigoCliente'].isnull()) & (df_ventas['Cliente'].isnull()) |
                        (df_ventas['CodigoTienda'].isnull()) & (df_ventas['Tienda'].isnull()))
            
            df_ventas = df_ventas[~filtro2].reset_index(drop=True)

            # Convertit a CSV en un objeto StringIO.
            ventas = io.StringIO()
            df_ventas.to_csv(ventas, index=False)
            ventas.seek(0)

            # Truncar la tabla Stg_Fact_Ventas.
            tabla = 'Stg_Fact_Ventas'
            cursor.execute(f'TRUNCATE TABLE {tabla}')
            print(f'Tabla {tabla} truncada.')

            # Leemos el CSV.
            csv_reader = csv.reader(ventas)
            header = next(csv_reader) # Saltar el encabezado.
            for line in csv_reader:
                    cursor.execute('''
                        INSERT INTO Stg_Fact_Ventas (FechaVenta, CodigoProducto, Producto, Cantidad, PrecioVenta, CodigoCliente, 
                                                Cliente, CodigoTienda, Tienda)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
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