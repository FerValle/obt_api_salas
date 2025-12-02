"""
Tests de integración para el endpoint POST /reservas
"""
import pytest

class TestReservas:
    """Tests para el endpoint de reservas de butacas"""
    
    def test_reserva_valida(self, client):
        """Test: crear reserva con datos válidos"""
        payload = {
            'idFuncion': 1,
            'idButaca': 1,
            'dni': '12.345.678'
        }
        response = client.post('/reservas', json=payload)
        assert response.status_code in [201, 409]  # 409 si ya está reservada
        data = response.get_json()
        assert 'mensaje' in data or 'error' in data
    
    def test_reserva_parametros_faltantes(self, client):
        """Test: faltan parámetros debe retornar 400"""
        payload = {
            'idFuncion': 1,
            'idButaca': 1
        }
        response = client.post('/reservas', json=payload)
        assert response.status_code == 400
        data = response.get_json()
        assert 'error' in data
        assert 'dni' in data['error'].lower()
    
    def test_reserva_funcion_inexistente(self, client):
        """Test: función inexistente debe retornar 404"""
        payload = {
            'idFuncion': 99999,
            'idButaca': 1,
            'dni': '12.345.678'
        }
        response = client.post('/reservas', json=payload)
        assert response.status_code == 404
        data = response.get_json()
        assert 'error' in data
    
    def test_reserva_butaca_inexistente(self, client):
        """Test: butaca inexistente debe retornar 404"""
        payload = {
            'idFuncion': 1,
            'idButaca': 99999,
            'dni': '12.345.678'
        }
        response = client.post('/reservas', json=payload)
        assert response.status_code == 404
        data = response.get_json()
        assert 'error' in data
    
    def test_reserva_duplicada(self, client):
        """Test: reservar butaca ya ocupada debe retornar 409"""
        payload = {
            'idFuncion': 1,
            'idButaca': 1,
            'dni': '12.345.678'
        }
        client.post('/reservas', json=payload)
        response = client.post('/reservas', json=payload)
        assert response.status_code == 409
        data = response.get_json()
        assert 'error' in data
