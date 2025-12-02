import os
import logging
from typing import Any
import mysql.connector
from mysql.connector import MySQLConnection, errorcode
from config import Config

os.makedirs(Config.LOG_DIR, exist_ok=True)
logging.basicConfig(
    level=getattr(logging, Config.LOG_LEVEL),
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(f'{Config.LOG_DIR}/app.log'),
        logging.StreamHandler()
    ]
)

def get_db_connection() -> MySQLConnection:
    """
    Crea y retorna una conexión a la base de datos MySQL.
    
    Returns:
        MySQLConnection: Conexión a la base de datos
        
    Raises:
        Exception: Si falla la conexión a la base de datos
    """
    config = {
        'user': Config.DB_USER,
        'password': Config.DB_PASSWORD,
        'host': Config.DB_HOST,
        'database': Config.DB_NAME,
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
