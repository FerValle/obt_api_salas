"""
API de Reservas de Cine - One Bit Tech
Entry point de la aplicación
"""
from api.routes import app
from config import Config

if __name__ == '__main__':
    app.run(
        host=Config.HOST,
        port=Config.PORT,
        debug=Config.DEBUG
    )
