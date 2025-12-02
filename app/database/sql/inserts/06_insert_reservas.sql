-- delete from reservas where idreserva !=0;
-- Wicked - 3D
INSERT INTO `test_db`.`Reservas` 
(`IdReserva`, `IdFuncion`, `IdPelicula`, `IdSala`, `IdButaca`, `DNI`, `FechaAlta`, `FechaBaja`, `EstaPagada`, `Observaciones`) VALUES
-- Funcion 14 - VIP
(1, 14, 15, 1, 1, '30.123.456', '2025-11-29 10:00:00', NULL, 'S', NULL),
(2, 14, 15, 1, 2, '30.123.457', '2025-11-29 10:05:00', NULL, 'S', NULL),
-- Funcion 16 - 3D
(3, 15, 15, 4, 16, '30.234.567', '2025-11-29 11:00:00', NULL, 'S', NULL),
(4, 15, 15, 4, 17, '30.234.568', '2025-11-29 11:10:00', NULL, 'N', NULL),
(5, 15, 15, 4, 18, '30.234.569', '2025-11-29 11:20:00', NULL, 'N', NULL);

-- Zootopia 2 - Estreno
INSERT INTO `test_db`.`Reservas` 
(`IdReserva`, `IdFuncion`, `IdPelicula`, `IdSala`, `IdButaca`, `DNI`, `FechaAlta`, `FechaBaja`, `EstaPagada`, `Observaciones`) VALUES
(6, 23, 14, 3, 9, '20.123.456', '2025-12-08 12:00:00', NULL, 'S', NULL),
(7, 23, 14, 3, 10, '20.123.456', '2025-11-29 12:05:00', NULL, 'N', NULL),
(8, 23, 14, 3, 11, '20.123.456', '2025-11-29 12:10:00', NULL, 'S', NULL),
(9, 23, 14, 3, 12, '20.123.456', '2025-11-29 12:15:00', NULL, 'N', NULL),
(10, 23, 14, 3, 13, '37.354.111', '2025-11-29 12:20:00', NULL, 'S', NULL),
(13, 24, 14, 4, 18, '32.266.790', '2025-11-29 13:10:00', NULL, 'S', NULL);

INSERT INTO `test_db`.`Reservas` 
(`IdReserva`, `IdFuncion`, `IdPelicula`, `IdSala`, `IdButaca`, `DNI`, `FechaAlta`, `FechaBaja`, `EstaPagada`, `Observaciones`) VALUES
(14, 24, 14, 4, 14, '44.111.222', '2025-11-29 13:10:00', NULL, 'S', NULL),
(15, 24, 14, 4, 15, '44.111.222', '2025-11-29 13:10:00', NULL, 'S', NULL),
(16, 24, 14, 4, 16, '44.111.222', '2025-11-29 13:10:00', NULL, 'S', NULL),
(17, 24, 14, 4, 17, '44.111.222', '2025-11-29 13:10:00', NULL, 'S', NULL);

INSERT INTO `test_db`.`Reservas` 
(`IdReserva`, `IdFuncion`, `IdPelicula`, `IdSala`, `IdButaca`, `DNI`, `FechaAlta`, `FechaBaja`, `EstaPagada`, `Observaciones`) VALUES
(18, 11, 13, 3, 9, '33.100.200', '2025-11-27 13:10:00', NULL, 'S', NULL),
(19, 15, 15, 4, 15, '33.100.200', '2025-11-29 13:10:00', NULL, 'S', NULL),
(20, 15, 15, 4, 19, '33.100.200', '2025-11-29 13:10:00', NULL, 'S', NULL);
 -- delete from butacas where idbutaca !=0;
  -- 
  -- delete from reservas where idreserva!=0;

-- Shelby Oaks
INSERT INTO `test_db`.`Reservas` 
(`IdReserva`, `IdFuncion`, `IdPelicula`, `IdSala`, `IdButaca`, `DNI`, `FechaAlta`, `FechaBaja`, `EstaPagada`, `Observaciones`) VALUES
-- Funcion 7
(21, 7, 17, 2, 6, '30.567.890', '2025-11-29 19:10:00', NULL, 'S', NULL),
(22, 7, 17, 2, 7, '30.567.890', '2025-11-29 19:10:00', NULL, 'S', NULL),
-- Funcion 9
(23, 9, 17, 2, 7, '30.567.777', '2025-12-01 20:10:00', NULL, 'S', NULL),
(24, 9, 17, 2, 8, '36.145.893', '2025-12-01 20:15:00', NULL, 'S', NULL);
