"""
Tests de integración para el endpoint GET /reporte/ocupacion
"""
import pytest

class TestReporteOcupacion:
    """Tests para el endpoint de reporte de ocupación"""
    
    def test_reporte_con_parametros_validos(self, client):
        """Test: generar reporte con parámetros válidos"""
        response = client.get(
            '/reporte/ocupacion?idPelicula=1&fechaInicio=2025-01-01&fechaFin=2025-12-31'
        )
        assert response.status_code in [200, 404]
        data = response.get_json()
        if response.status_code == 200:
            assert isinstance(data, list)
    
    def test_reporte_sin_parametros(self, client):
        """Test: sin parámetros debe retornar 400"""
        response = client.get('/reporte/ocupacion')
        assert response.status_code == 400
        data = response.get_json()
        assert 'error' in data
    
    def test_reporte_parametro_faltante(self, client):
        """Test: falta fechaFin debe retornar 400"""
        response = client.get('/reporte/ocupacion?idPelicula=1&fechaInicio=2025-01-01')
        assert response.status_code == 400
        data = response.get_json()
        assert 'error' in data
    
    def test_reporte_fecha_formato_invalido(self, client):
        """Test: formato de fecha inválido debe retornar 400"""
        response = client.get(
            '/reporte/ocupacion?idPelicula=1&fechaInicio=01-01-2025&fechaFin=2025-12-31'
        )
        assert response.status_code == 400
        data = response.get_json()
        assert 'error' in data
        assert 'YYYY-MM-DD' in data['error']
    
    def test_reporte_pelicula_inexistente(self, client):
        """Test: película que no existe debe retornar 404"""
        response = client.get(
            '/reporte/ocupacion?idPelicula=99999&fechaInicio=2025-01-01&fechaFin=2025-12-31'
        )
        assert response.status_code == 404
        data = response.get_json()
        assert 'error' in data
