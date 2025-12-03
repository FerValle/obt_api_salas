-- Sala 1 - Cines del Solar - VIP
INSERT INTO `test_db`.`Butacas` 
(`idButaca`, `IdSala`, `NroButaca`, `Fila`, `Columna`, `Estado`, `Observaciones`) VALUES
(1, 1, 14, 7, 2, 'A', 'VIP'),
(2, 1, 15, 7, 3, 'A', 'VIP'),
(3, 1, 16, 7, 4, 'A', 'VIP'),
(4, 1, 10, 4, 4, 'A', 'VIP'),
(5, 1, 11, 4, 5, 'A', 'VIP');

-- Sala 2 - Cines del Solar - N
INSERT INTO `test_db`.`Butacas` 
(`idButaca`, `IdSala`, `NroButaca`, `Fila`, `Columna`, `Estado`, `Observaciones`) VALUES
(6, 2, 1, 7, 4, 'A', NULL),
(7, 2, 2, 7, 5, 'A', NULL),
(8, 2, 3, 7, 6, 'A', NULL);

-- Sala 3 - Cines del Solar - 3D
INSERT INTO `test_db`.`Butacas` 
(`idButaca`, `IdSala`, `NroButaca`, `Fila`, `Columna`, `Estado`, `Observaciones`) VALUES
(9, 3, 1, 1, 1, 'A', '3D'),
(10, 3, 2, 1, 2, 'A', '3D'),
(11, 3, 3, 1, 3, 'A', '3D'),
(12, 3, 4, 2, 1, 'A', '3D'),
(13, 3, 5, 2, 2, 'A', '3D');

-- Sala 4 - Cines del Solar - 3D
INSERT INTO `test_db`.`Butacas` 
(`idButaca`, `IdSala`, `NroButaca`, `Fila`, `Columna`, `Estado`, `Observaciones`) VALUES
(14, 4, 22, 15, 6, 'A', '3D'),
(15, 4, 23, 15, 7, 'A', '3D'),
(16, 4, 24, 15, 8, 'A', '3D'),
(17, 4, 12, 7, 3, 'A', '3D'),
(18, 4, 13, 7, 4, 'A', '3D'),
(19, 4, 14, 7, 5, 'A', '3D'),
(20, 4, 15, 7, 6, 'A', '3D'),
(21, 4, 16, 7, 7, 'A', '3D');

-- Sala 5 - Cines del Solar - N
INSERT INTO `test_db`.`Butacas` 
(`idButaca`, `IdSala`, `NroButaca`, `Fila`, `Columna`, `Estado`, `Observaciones`) VALUES
(22, 5, 14, 10, 5, 'A', NULL),
(23, 5, 15, 10, 6, 'A', NULL),
(24, 5, 23, 16, 4, 'A', NULL);
