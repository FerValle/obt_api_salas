import os
import logging
from typing import Tuple, Any
from dotenv import load_dotenv
from flask import Flask, request, jsonify, Response
from flasgger import Swagger, swag_from
from db import get_db_connection
from utils import validar_fecha

load_dotenv()
app = Flask(__name__)

swagger = Swagger(app, template={
    "info": {
        "title": "API de Reservas de Cine",
        "description": "API para gestionar reservas, consultar precios y generar reportes de ocupación",
        "version": "1.0.0"
    }
})

@app.route('/precios/<int:idFuncion>', methods=['GET'])
@swag_from('swagger/precios.yml')
def determinar_precio_entrada(idFuncion: int) -> Tuple[Response, int]:
    try:
        if not idFuncion or idFuncion <= 0:
            return jsonify({'error': 'idFuncion es requerido y debe ser mayor a 0'}), 400
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.callproc('sp_DeterminarPrecioEntrada', [idFuncion])
        for result in cursor.stored_results():
            data = result.fetchall()
            columns = result.column_names
            if columns and 'Precio' in columns:
                precio = data[0][columns.index('Precio')]
                return jsonify({'precio': float(precio)})
            elif columns and 'MensajeError' in columns:
                error_msg = data[0][0]
                if 'inexistente' in error_msg.lower() or 'no existe' in error_msg.lower():
                    return jsonify({'error': error_msg}), 404
                return jsonify({'error': error_msg}), 400
        return jsonify({'error': 'Sin respuesta del procedimiento'}), 500
    except Exception as e:
        error_msg = str(e)
        if 'foreign key constraint fails' in error_msg.lower():
            return jsonify({'error': 'La función seleccionada no existe'}), 404
        elif 'connection' in error_msg.lower() or 'timeout' in error_msg.lower():
            return jsonify({'error': 'Error de conexión con la base de datos'}), 500
        else:
            return jsonify({'error': 'Error al obtener el precio.'}), 500
    finally:
        try:
            cursor.close()
            conn.close()
        except Exception as e:
            logging.error(f'Error al cerrar conexión: {str(e)}')

@app.route('/reporte/ocupacion', methods=['GET'])
@swag_from('swagger/reporte_ocupacion.yml')
def reporte_ocupacion() -> Tuple[Response, int]:
    id_pelicula = request.args.get('idPelicula', type=int)
    fecha_inicio = request.args.get('fechaInicio')
    fecha_fin = request.args.get('fechaFin')
    
    if not id_pelicula or not fecha_inicio or not fecha_fin:
        return jsonify({'error': 'Faltan parámetros: idPelicula, fechaInicio, fechaFin'}), 400
    
    error_response, status_code = validar_fecha(fecha_inicio, 'fechaInicio')
    if error_response:
        return error_response, status_code
    
    error_response, status_code = validar_fecha(fecha_fin, 'fechaFin')
    if error_response:
        return error_response, status_code
    
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.callproc('sp_ReporteOcupacionPorPelicula', [id_pelicula, fecha_inicio, fecha_fin])
        for result in cursor.stored_results():
            data = result.fetchall()
            columns = result.column_names
            if columns and 'MensajeError' in columns:
                error_msg = data[0][0]
                if 'inexistente' in error_msg.lower() or 'no existe' in error_msg.lower():
                    return jsonify({'error': error_msg}), 404
                return jsonify({'error': error_msg}), 400
            reporte = [dict(zip(columns, row)) for row in data]
            return jsonify(reporte)
        return jsonify({'error': 'Sin respuesta del procedimiento'}), 500
    except Exception as e:
        error_msg = str(e)
        if 'foreign key constraint fails' in error_msg.lower():
            return jsonify({'error': 'La película seleccionada no existe'}), 404
        elif 'connection' in error_msg.lower() or 'timeout' in error_msg.lower():
            return jsonify({'error': 'Error de conexión con la base de datos'}), 500
        else:
            return jsonify({'error': 'Error al generar el reporte.'}), 500
    finally:
        try:
            cursor.close()
            conn.close()
        except Exception as e:
            logging.error(f'Error al cerrar conexión: {str(e)}')

@app.route('/reservas', methods=['POST'])
@swag_from('swagger/reservas.yml')
def reservar_butaca() -> Tuple[Response, int]:
    data = request.get_json()
    if not data:
        return jsonify({'error': 'Faltan datos para reserva'}), 400
    
    id_funcion = data.get('idFuncion')
    id_butaca = data.get('idButaca')
    dni = data.get('dni')
    
    if not id_funcion or not id_butaca or not dni:
        return jsonify({'error': 'Faltan parámetros: idFuncion, idButaca, dni'}), 400
    
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.callproc('sp_ReservarButacaConValidacionDNI', [id_funcion, id_butaca, dni])
        for result in cursor.stored_results():
            data = result.fetchall()
            columns = result.column_names
            if columns and 'MensajeError' in columns:
                error_msg = data[0][0]
                if 'inexistente' in error_msg.lower() or 'no existe' in error_msg.lower():
                    return jsonify({'error': error_msg}), 404
                elif 'ya tiene' in error_msg.lower() or 'reservas activas' in error_msg.lower():
                    return jsonify({'error': error_msg}), 409
                return jsonify({'error': error_msg}), 400
            elif columns and 'Mensaje' in columns:
                mensaje = data[0][0]
                if mensaje == 'OK':
                    conn.commit()
                    return jsonify({'mensaje': 'Reserva creada exitosamente'}), 201
                else:
                    return jsonify({'mensaje': mensaje}), 200
        return jsonify({'error': 'Sin respuesta del procedimiento'}), 500
    except Exception as e:
        conn.rollback()
        error_msg = str(e)
        if 'foreign key constraint fails' in error_msg.lower():
            if 'FK_Reservas_Butacas' in error_msg or 'butacas' in error_msg.lower():
                return jsonify({'error': 'La butaca seleccionada no existe o no pertenece a la sala de la función'}), 404
            elif 'FK_Reservas_Funciones' in error_msg or 'funciones' in error_msg.lower():
                return jsonify({'error': 'La función seleccionada no existe'}), 404
            else:
                return jsonify({'error': 'Los datos de la reserva son inválidos'}), 400
        elif 'duplicate entry' in error_msg.lower():
            return jsonify({'error': 'La butaca ya está reservada para esta función'}), 409
        else:
            return jsonify({'error': 'Error al procesar la reserva. Verifique los datos e intente nuevamente'}), 500
    finally:
        try:
            cursor.close()
            conn.close()
        except Exception as e:
            logging.error(f'Error al cerrar conexión: {str(e)}')


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='127.0.0.1', port=port, debug=True)
