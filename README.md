# API de Salas de cine - One Bit Tech

API REST para gestionar reservas, consultar precios de funciones y generar reportes de ocupación.

## Características

- **Consulta de precios**: Obtener precio de entrada para una función específica
- **Reportes de ocupación**: Generar reportes de ocupación por película en un rango de fechas
- **Gestión de reservas**: Crear reservas con validación de DNI y límite de 4 reservas por día


## Requisitos

- Python 3.8+
- MySQL 8.0+
- pip

## Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/FerValle/obt_api_salas.git
cd obt_api_salas/app
```

### 2. Crear entorno virtual

```bash
python -m venv .venv
source .venv/bin/activate  # En Windows: .venv\Scripts\activate
```

### 3. Instalar dependencias

```bash
python -m pip install -r requirements.txt
```

### 4. Configurar variables de entorno

Copiar el archivo de ejemplo y configurar las variables:

```bash
cp .env.example .env
```

Editar `.env` con tus credenciales:

```env
DB_USER=tu_usuario
DB_PASSWORD=tu_password
DB_HOST=127.0.0.1
DB_NAME=test_db
PORT=5000
DEBUG=True
```

### 5. Configurar la base de datos

*Usando MySQL Workbench u otro cliente GUI*

1. Abrir MySQL Workbench y conectar a tu servidor MySQL
2. Ir a `File → Open SQL Script`
3. Ejecutar cada archivo en este orden:
   - `database/sql/tables/set_up_db.sql`
   - `database/sql/inserts/01_insert_generos.sql`
   - `database/sql/inserts/02_insert_peliculas.sql`
   - `database/sql/inserts/03_insert_salas.sql`
   - `database/sql/inserts/04_insert_butacas.sql`
   - `database/sql/inserts/05_insert_funciones.sql`
   - `database/sql/inserts/06_insert_reservas.sql`
   - `database/sql/procedures/sp_determinar_precio_entrada.sql`
   - `database/sql/procedures/sp_reporte_ocupacion_por_pelicula.sql`
   - `database/sql/procedures/sp_reservar_butaca_con_validacion_dni.sql`

## Ejecución

### Modo desarrollo

```bash
python app.py
```
### Para consultar API:
Abrir en el navegador: `http://127.0.0.1:5000/apidocs`

## Endpoints

### GET /precios/{idFuncion}

Obtener el precio de una función.

**Ejemplo:**
```bash
curl http://127.0.0.1:5000/precios/14
```

**Respuesta:**
```json
{
  "precio": 3465.00
}
```

### GET /reporte/ocupacion

Generar reporte de ocupación por película.

**Parámetros:**
- `idPelicula` (int): ID de la película
- `fechaInicio` (date): Fecha inicio (YYYY-MM-DD)
- `fechaFin` (date): Fecha fin (YYYY-MM-DD)

**Ejemplo:**
```bash
curl "http://127.0.0.1:5000/reporte/ocupacion?idPelicula=14&fechaInicio=2025-01-01&fechaFin=2025-12-31"
```

### POST /reservas

Crear una reserva de butaca.

**Body:**
```json
{
  "idFuncion": 12,
  "idButaca": 10,
  "dni": "35.123.789"
}
```

**Ejemplo:**
```bash
curl -X POST http://127.0.0.1:5000/reservas \
  -H "Content-Type: application/json" \
  -d '{"idFuncion": 12, "idButaca": 10, "dni": "35.123.789"}'
```
