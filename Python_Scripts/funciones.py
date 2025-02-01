import configparser
import pyodbc
import os

def conectar_base() -> pyodbc.Connection:    

    '''
    Esta funcion se conecta a nuestra base de datos. 
    No recibe argumentos, y devuelve dos objetos:

    conn = pyodbc.connect() -> Conectarse a la base de datos a traves de ODBC
    cursor = conn.cursor() -> Permite crear consultas en SQL
    '''

    # Crear una instancia de ConfigParser.
    config = configparser.ConfigParser()

    # Directorio actual.
    script_path = os.path.dirname(__file__)

    # Leer archivo de la configuración.
    doc_config = os.path.join(script_path, 'config.ini')
    config.read(doc_config)

    if 'database' in config:
        print("La sección 'database' fue encontrada.")

        # Acceder a los datos de la configuración.
        db_config = {
            'driver': config['database']['driver'],
            'server': config['database']['server'],
            'database': config['database']['database'],
            'Trusted_Connection': config['database']['Trusted_Connection']
                    }
        print('Datos de configuración ok.')
        
        # Construir la cadena de conexión.
        connection_string = (
            f"DRIVER={{{db_config['driver']}}};"
            f"SERVER={db_config['server']};"
            f"DATABASE={db_config['database']};"
            f"Trusted_Connection={db_config['Trusted_Connection']};"
                            )
        print('Cadena de conexión ok.')
        
        try:
            conn = pyodbc.connect(connection_string)
            cursor = conn.cursor()
            print('Conexion exitosa.')   

        except pyodbc.Error as expy:
            conn = None
            print('Error --> Error en funcion al conectar la base: ', expy)

        except FileNotFoundError as ex:
            conn = None
            print('Error --> El archivo no se encontro desde la funcion: ', ex)

    else:
        print("La seccion 'database' no fue encontrada en el archivo de configuracion, desde la funcion.")
        print('No se está usando la base desde la funcion.')

    return conn, cursor 

def desconectar_base(conn: pyodbc.Connection, cursor) -> bool:

    '''
    Esta funcion permite desconectarse de la base de datos.
    Recibe los objetos de la conexion, mencionados anteriormente, 
    para asegurarse de que si la conexion existe, se ejecuten las
    transacciones pendientes y se cierre cuando lo haga.  
    
    '''

    base_desconectada = False

    if conn:  # Verificar si la conexión existe
        try:
            conn.commit()  # Asegurarse de que cualquier transacción pendiente se complete
            cursor.close()
            conn.close()  # Cerrar la conexión
            base_desconectada = True
            
        except Exception as e:
            base_desconectada = False
            print(f"Error al desconectar la base desde la funcion: {e}")
            
    else:
        base_desconectada = False
        print('No hay conexión activa para desconectar desde la funcion.')
        
    return base_desconectada