DELIMITER //
CREATE PROCEDURE sp_DeterminarPrecioEntrada(
    IN pIdFuncion INT,
    OUT pPrecioFinal DECIMAL(12,2),
    OUT pMensaje VARCHAR(100)
)
SALIR: BEGIN
    DECLARE vPrecioFinal DECIMAL(12,2);
    DECLARE vIdGenero SMALLINT;
    DECLARE vGenero VARCHAR(50);
    DECLARE vIdSala SMALLINT;

    SET pPrecioFinal = NULL;
    SET pMensaje = NULL;

    IF pIdFuncion IS NULL OR pIdFuncion <= 0 THEN
        SET pMensaje = 'IdFuncion inválido';
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
        SET pMensaje = 'Función inválida';
        LEAVE SALIR;
    END IF;

    IF UPPER(vGenero) IN ('ESTRENO', '3D') THEN
        SET vPrecioFinal = vPrecioFinal * 1.10;
    END IF;

    IF vIdSala = 1 THEN
        SET vPrecioFinal = vPrecioFinal * 1.05;
    END IF;

    SET pPrecioFinal = vPrecioFinal;
    SET pMensaje = 'OK';
END //
DELIMITER ;
