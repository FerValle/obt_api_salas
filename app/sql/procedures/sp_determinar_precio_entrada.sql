DELIMITER //
CREATE PROCEDURE sp_DeterminarPrecioEntrada(
    IN pIdFuncion INT
)
SALIR: BEGIN
    DECLARE vPrecioFinal DECIMAL(12,2);
    DECLARE vIdGenero SMALLINT;
    DECLARE vGenero VARCHAR(50);
    DECLARE vIdSala SMALLINT;
    DECLARE vMensaje VARCHAR(100);

    SET vPrecioFinal = NULL;
    SET vMensaje = NULL;

    IF pIdFuncion IS NULL OR pIdFuncion <= 0 THEN
        SELECT 'Error: IdFuncion inválido' AS MensajeError;
        LEAVE SALIR;
    END IF;

    SELECT f.Precio, p.IdGenero, g.Genero, f.IdSala
        INTO vPrecioFinal, vIdGenero, vGenero, vIdSala
        FROM Funciones f
        JOIN Peliculas p ON f.IdPelicula = p.idPelicula
        JOIN Generos g ON p.IdGenero = g.IdGenero
        WHERE f.idFuncion = pIdFuncion
            AND f.Estado = 'A'
            AND (f.FechaFin IS NULL OR f.FechaFin > NOW());

    IF vPrecioFinal IS NULL THEN
        SELECT 'Error: Función inválida' AS MensajeError;
        LEAVE SALIR;
    END IF;

    IF UPPER(vGenero) IN ('ESTRENO', '3D') THEN
        SET vPrecioFinal = vPrecioFinal * 1.10;
    END IF;

    IF vIdSala = 1 THEN
        SET vPrecioFinal = vPrecioFinal * 1.05;
    END IF;

    SELECT vPrecioFinal AS Precio;
END //
DELIMITER ;
