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
