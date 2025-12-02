"""
Configuración compartida para tests
"""
import pytest
import os
from app.app import app as flask_app

@pytest.fixture
def app():
    """Fixture que provee la aplicación Flask configurada para tests"""
    flask_app.config.update({
        "TESTING": True,
    })
    yield flask_app

@pytest.fixture
def client(app):
    """Fixture que provee un cliente de test para hacer requests"""
    return app.test_client()

@pytest.fixture
def runner(app):
    """Fixture que provee un CLI runner"""
    return app.test_cli_runner()
