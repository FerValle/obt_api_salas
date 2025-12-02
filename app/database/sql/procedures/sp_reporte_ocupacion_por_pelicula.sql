DELIMITER //
CREATE PROCEDURE sp_ReporteOcupacionPorPelicula(
    IN pIdPelicula INT,
    IN pFechaInicio DATE,
    IN pFechaFin DATE
)
SALIR: BEGIN
        DECLARE vExistePelicula INT DEFAULT 0;

        IF pIdPelicula IS NULL OR pIdPelicula <= 0 THEN
            SELECT 'Error: IdPelicula inválido' AS MensajeError;
            LEAVE SALIR;
        END IF;

        SELECT COUNT(*) INTO vExistePelicula FROM Peliculas WHERE idPelicula = pIdPelicula;
        IF vExistePelicula = 0 THEN
            SELECT 'Error: Película inexistente' AS MensajeError;
            LEAVE SALIR;
        END IF;

    IF pFechaInicio IS NULL OR pFechaFin IS NULL THEN
        SELECT 'Error: Las fechas no pueden ser nulas' AS MensajeError;
        LEAVE SALIR;
    END IF;

    IF pFechaInicio > pFechaFin THEN
        SELECT 'Error: La fecha de inicio debe ser menor o igual a la fecha de fin' AS MensajeError;
        LEAVE SALIR;
    END IF;

        SELECT 
            f.idFuncion,
            CAST(TIME(f.FechaInicio) AS CHAR) AS HoraInicio,
            f.IdSala,
            s.Sala AS NombreSala,
            COUNT(r.idReserva) AS TotalButacasVendidas,
            IFNULL(SUM(CASE WHEN UPPER(r.EstaPagada) = 'S' THEN 1 ELSE 0 END) * f.Precio, 0) AS TotalIngresosRecaudados
        FROM Funciones f
        JOIN Salas s ON f.IdSala = s.IdSala
        LEFT JOIN Reservas r ON r.IdFuncion = f.idFuncion
        WHERE f.IdPelicula = pIdPelicula
            AND f.Estado = 'A'
            AND f.FechaInicio IS NOT NULL
            AND DATE(f.FechaInicio) BETWEEN pFechaInicio AND pFechaFin
        GROUP BY f.idFuncion, f.FechaInicio, f.IdSala, s.Sala, f.Precio
        ORDER BY f.FechaInicio;
END //
DELIMITER ;
