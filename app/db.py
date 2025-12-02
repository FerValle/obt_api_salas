import os
import logging
from dotenv import load_dotenv
import mysql.connector
from mysql.connector import errorcode

os.makedirs('logs', exist_ok=True)
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/app.log'),
        logging.StreamHandler()
    ]
)

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
            logging.error(f'Error de acceso a MySQL: {err}')
            raise Exception('Error: Usuario o contraseña incorrectos para MySQL')
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            logging.error(f'Base de datos no encontrada: {err}')
            raise Exception('Error: La base de datos no existe')
        else:
            logging.error(f'Error de conexión a MySQL: {err}')
            raise Exception(f'Error de conexión a MySQL: {err}')
