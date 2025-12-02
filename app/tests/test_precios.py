"""
Tests de integración para el endpoint GET /precios/<idFuncion>
"""
import pytest

class TestDeterminarPrecioEntrada:
    """Tests para el endpoint de determinación de precios"""
    
    def test_precio_con_id_valido(self, client):
        """Test: obtener precio de una función válida"""
        response = client.get('/precios/14')
        assert response.status_code == 200
        data = response.get_json()
        assert 'precio' in data
        assert isinstance(data['precio'], (int, float))
        assert data['precio'] > 0
    
    def test_precio_funcion_inexistente(self, client):
        """Test: función que no existe debe retornar 404"""
        response = client.get('/precios/999')
        assert response.status_code == 404
        data = response.get_json()
        assert 'error' in data
    
    def test_precio_id_invalido(self, client):
        """Test: idFuncion = 0 debe retornar 400"""
        response = client.get('/precios/0')
        assert response.status_code == 400
        data = response.get_json()
        assert 'error' in data
