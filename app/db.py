import os
from dotenv import load_dotenv
import mysql.connector
from mysql.connector import errorcode


def get_db_connection():
    load_dotenv()
    config = {
        'user': os.environ.get('DB_USER', 'root'),
        'password': os.environ.get('DB_PASSWORD', ''),
        'host': os.environ.get('DB_HOST', '127.0.0.1'),
        'database': os.environ.get('DB_NAME', 'test_db'),
        'raise_on_warnings': True
    }
    try:
        conn = mysql.connector.connect(**config)
        return conn
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            raise Exception('Error: Usuario o contraseña incorrectos para MySQL')
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            raise Exception('Error: La base de datos no existe')
        else:
            raise Exception(f'Error de conexión a MySQL: {err}')
