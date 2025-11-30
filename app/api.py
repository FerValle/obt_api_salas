
import os
from dotenv import load_dotenv
from flask import Flask, jsonify
from db import get_db_connection


load_dotenv()
app = Flask(__name__)

@app.route('/precios/<int:idFuncion>', methods=['GET'])
def determinar_precio_entrada(idFuncion):
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
                return jsonify({'error': data[0][0]}), 400
        return jsonify({'error': 'Sin respuesta del procedimiento'}), 500
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    finally:
        try:
            cursor.close()
            conn.close()
        except:
            pass

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='127.0.0.1', port=port, debug=True)
