# Tests

Tests de integración que validan los endpoints de la API contra la base de datos.

## Ejecutar tests

Todos los tests:
```bash
pytest
```

Con verbose:
```bash
pytest -v
```

Tests específicos:
```bash
pytest tests/test_precios.py
pytest tests/test_reporte.py
pytest tests/test_reservas.py
```

Un test específico:
```bash
pytest tests/test_precios.py::TestDeterminarPrecioEntrada::test_precio_con_id_valido
```

## Cobertura

Para ver cobertura de código:
```bash
pip install pytest-cov
pytest --cov=. --cov-report=html
```

Luego abrí `htmlcov/index.html` en el navegador.

## Estructura

```
tests/
├── __init__.py
├── conftest.py          # Fixtures compartidos (app, client)
├── test_precios.py      # Tests para GET /precios/<id>
├── test_reporte.py      # Tests para GET /reporte/ocupacion
├── test_reservas.py     # Tests para POST /reservas
└── test_validators.py   # Tests unitarios para validadores
```

## Notas

- Los tests de integración usan la DB configurada en `.env`
- Asegurate de tener datos de prueba en la DB antes de correr los tests
- Los tests de reservas pueden modificar datos (usar DB de test separada)
