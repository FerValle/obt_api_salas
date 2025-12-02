"""
API de Reservas de Cine - One Bit Tech
Entry point de la aplicación
"""
import os
import logging
from flask import Flask
from flasgger import Swagger
from config import Config
from api.routes import api_bp

os.makedirs(Config.LOG_DIR, exist_ok=True)
logging.basicConfig(
    level=getattr(logging, Config.LOG_LEVEL),
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    filename=f'{Config.LOG_DIR}/app.log'
)

app = Flask(__name__)

swagger = Swagger(app, template={
    "info": {
        "title": "API de Reservas de Cine",
        "description": "API para gestionar reservas, consultar precios y generar reportes de ocupación",
        "version": "1.0.0"
    }
})

app.register_blueprint(api_bp)

if __name__ == '__main__':
    app.run(
        host=Config.HOST,
        port=Config.PORT,
        debug=Config.DEBUG
    )
