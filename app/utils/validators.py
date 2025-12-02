from datetime import datetime
from typing import Optional, Tuple
from flask import jsonify, Response

def validar_fecha(fecha: Optional[str], nombre_campo: str) -> Tuple[Optional[Response], Optional[int]]:
    """
    Valida que una fecha tenga formato YYYY-MM-DD y sea válida.
    
    Args:
        fecha: String con la fecha a validar
        nombre_campo: Nombre del campo para el mensaje de error
        
    Returns:
        tuple: (None, None) si es válida, (json_response, status_code) si hay error
    """
    if not fecha:
        return jsonify({'error': f'{nombre_campo} es requerido'}), 400
    
    try:
        datetime.strptime(fecha, '%Y-%m-%d')
        return None, None
    except ValueError:
        return jsonify({'error': f'{nombre_campo} debe tener formato YYYY-MM-DD y ser una fecha válida'}), 400
