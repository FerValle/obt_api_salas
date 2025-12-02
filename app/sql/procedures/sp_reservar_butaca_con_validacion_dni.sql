DELIMITER //
CREATE PROCEDURE sp_ReservarButacaConValidacionDNI(
  IN pIdFuncion INT,
  IN pIdButaca INT,
  IN pDNI VARCHAR(11)
)
SALIR: BEGIN
  DECLARE vFechaInicio DATE;
  DECLARE vReservasActivas INT DEFAULT 0;
  DECLARE vMensaje VARCHAR(50);

  IF pIdFuncion IS NULL OR pIdFuncion <= 0 THEN
    SELECT 'Error: IdFuncion inválido' AS MensajeError;
    LEAVE SALIR;
  END IF;

  IF pIdButaca IS NULL OR pIdButaca <= 0 THEN
    SELECT 'Error: IdButaca inválido' AS MensajeError;
    LEAVE SALIR;
  END IF;

  IF pDNI IS NULL OR NOT (TRIM(pDNI) REGEXP '^[0-9]{2}\.[0-9]{3}\.[0-9]{3}$') THEN
    SELECT 'Error: DNI inválido' AS MensajeError;
    LEAVE SALIR;
  END IF;

  SELECT DATE(FechaInicio) INTO vFechaInicio
    FROM Funciones
    WHERE idFuncion = pIdFuncion;

  IF vFechaInicio IS NULL THEN
    SELECT 'Error: Función inexistente' AS MensajeError;
    LEAVE SALIR;
  END IF;

  SELECT COUNT(*) INTO vReservasActivas
    FROM Reservas r
    JOIN Funciones f
    ON r.IdFuncion = f.idFuncion
  WHERE r.DNI = pDNI
    AND UPPER(r.EstaPagada) = 'S'
    AND r.FechaBaja IS NULL
    AND DATE(f.FechaInicio) = vFechaInicio;

  IF vReservasActivas >= 4 THEN
    SELECT 'Error: El DNI ya tiene 4 reservas activas para esa fecha' AS MensajeError;
    LEAVE SALIR;
  END IF;

  INSERT INTO Reservas (IdFuncion, IdPelicula, IdSala, IdButaca, DNI, FechaAlta, EstaPagada)
  SELECT f.idFuncion, f.IdPelicula, f.IdSala, pIdButaca, pDNI, NOW(), 'S'
    FROM Funciones f
    WHERE f.idFuncion = pIdFuncion;

  SELECT 'OK' AS Mensaje;
END //
DELIMITER ;
