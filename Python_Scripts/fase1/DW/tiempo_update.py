import os
import sys

# Directorio actual STG.
script_path = os.path.dirname(__file__)

# Directorio fase1.
fase1_path = os.path.abspath(os.path.join(script_path, '..'))  # Sube un nivel

# Directorio Python_Scripts.
python_scripts_path = os.path.abspath(os.path.join(fase1_path, '..'))  # Sube un nivel
sys.path.append(python_scripts_path)
from funciones import * # Importamos las funciones para conectar y desconectar la base de datos

def main():

    conn = None
    cursor = None

    try: 
        # Conectar a la base de datos
        conn, cursor = conectar_base()

        if conn:

            # Ejecutar el stored procedure
            stored_procedure = 'Sp_Genera_Dim_Tiempo'

            #Traer los años para utilizar el SP
            cursor.execute('''SELECT DISTINCT YEAR(FechaVenta)
                            FROM Int_Fact_Ventas''')

            #Iteramos cada uno de los valores para el SP
            for row in cursor.fetchall():
                param = row[0]
                cursor.execute(f'EXEC {stored_procedure} ?', param)

            # Confirmar ejecucion
            conn.commit()
            print(f'Stored procedure {stored_procedure} ejecutado exitosamente.')
            print('Tabla Dim_Tiempo actualizada con éxito')

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