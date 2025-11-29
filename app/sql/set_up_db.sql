DROP SCHEMA IF EXISTS `test_db` ;

CREATE SCHEMA IF NOT EXISTS `test_db` DEFAULT CHARACTER SET utf8 ;
USE `test_db` ;

-- --------------------------------------------------
-- Salas
-- --------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`Salas` (
  `IdSala` SMALLINT NOT NULL,
  `Sala` VARCHAR(60) NOT NULL,
  `TipoSala` CHAR(1) NOT NULL,
  `Direccion` VARCHAR(60) NOT NULL,
  `Estado` CHAR(1) NOT NULL,
  `Observaciones` VARCHAR(255) NULL,
  PRIMARY KEY (`IdSala`),
  UNIQUE INDEX `AK_Salas_Sala` (`Sala` ASC),
  CONSTRAINT `CK_Salas_Estado_AI` CHECK (`Estado` IN ('A','I')))
ENGINE = InnoDB;

-- -------------------------------------------------
-- Generos
-- -------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`Generos` (
  `IdGenero` SMALLINT NOT NULL,
  `Genero` VARCHAR(50) NOT NULL,
  `Estado` CHAR(1) NOT NULL,
  PRIMARY KEY (`IdGenero`),
  UNIQUE INDEX `AK_Generos_Genero` (`Genero` ASC),
  CONSTRAINT `CK_Generos_Estado_AI` CHECK (`Estado` IN ('A','I')))
ENGINE = InnoDB;

-- ------------------------------------------------
-- Butacas
-- ------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`Butacas` (
  `idButaca` INT NOT NULL,
  `IdSala` SMALLINT NOT NULL,
  `NroButaca` SMALLINT NOT NULL,
  `Fila` SMALLINT NOT NULL,
  `Columna` SMALLINT NOT NULL,
  `Estado` CHAR(1) NOT NULL,
  `Observaciones` VARCHAR(255) NULL,
  PRIMARY KEY (`idButaca`, `IdSala`),
  INDEX `AK_Butacas_NroButaca_IdSala` (`NroButaca` ASC, `IdSala` ASC),
  INDEX `FK_Butacas_Salas_idx` (`IdSala` ASC),
  CONSTRAINT `FK_Butacas_Salas`
    FOREIGN KEY (`IdSala`)
    REFERENCES `test_db`.`Salas` (`IdSala`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `CK_Butacas_Estado_AI` CHECK (`Estado` IN ('A','I')))
ENGINE = InnoDB;

-- -------------------------------------------------
-- Peliculas
-- -------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`Peliculas` (
  `idPelicula` INT NOT NULL,
  `IdGenero` SMALLINT NOT NULL,
  `Pelicula` VARCHAR(100) NOT NULL,
  `Sinopsis` TEXT NOT NULL,
  `Duracion` SMALLINT NOT NULL,
  `Actores` LONGTEXT NOT NULL,
  `Estado` CHAR(1) NOT NULL,
  `Observaciones` VARCHAR(255) NULL,
  PRIMARY KEY (`idPelicula`),
  INDEX `FK_Peliculas_Genero_idx` (`IdGenero` ASC),
  CONSTRAINT `FK_Peliculas_Genero`
    FOREIGN KEY (`IdGenero`)
    REFERENCES `test_db`.`Generos` (`IdGenero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `CK_Peliculas_Estado_AI` CHECK (`Estado` IN ('A','I')))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Funciones
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`Funciones` (
  `idFuncion` INT NOT NULL AUTO_INCREMENT,
  `IdPelicula` INT NOT NULL,
  `IdSala` SMALLINT NOT NULL,
  `FechaProbableInicio` DATETIME NOT NULL,
  `FechaProbableFin` DATETIME NOT NULL,
  `FechaInicio` DATETIME NULL,
  `FechaFin` DATETIME NULL,
  `Precio` DECIMAL(12,2) NOT NULL,
  `Estado` CHAR(1) NOT NULL,
  `Observaciones` VARCHAR(255) NULL,
  PRIMARY KEY (`idFuncion`, `IdPelicula`, `IdSala`),
  INDEX `AK_Funciones_IdFuncion` (`idFuncion` ASC),
  INDEX `FK_Funciones_Salas_idx` (`IdSala` ASC),
  INDEX `FK_Funciones_Peliculas_idx` (`IdPelicula` ASC),
  CONSTRAINT `FK_Funciones_Salas`
    FOREIGN KEY (`IdSala`)
    REFERENCES `test_db`.`Salas` (`IdSala`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Funciones_Peliculas`
    FOREIGN KEY (`IdPelicula`)
    REFERENCES `test_db`.`Peliculas` (`idPelicula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `CK_Funciones_Precio_Mayor_0` CHECK (`Precio` > 0),
  CONSTRAINT `CK_Funciones_Estado_AI` CHECK (`Estado` IN ('A','I')),
  CONSTRAINT `CK_Funciones_Fechas` CHECK ((`FechaInicio` IS NULL OR `FechaFin` IS NULL OR `FechaInicio` < `FechaFin`)),
  CONSTRAINT `CK_Funciones_FechasProbables` CHECK (`FechaProbableInicio` <= `FechaProbableFin`)
)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Reservas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`Reservas` (
  `idReserva` BIGINT NOT NULL AUTO_INCREMENT,
  `IdFuncion` INT NOT NULL,
  `IdPelicula` INT NOT NULL,
  `IdSala` SMALLINT NOT NULL,
  `IdButaca` INT NOT NULL,
  `DNI` VARCHAR(11) NOT NULL,
  `FechaAla` DATETIME NOT NULL,
  `FechaBaja` DATETIME NULL,
  `EstaPagada` CHAR(1) NOT NULL,
  `Observaciones` VARCHAR(255) NULL,
  PRIMARY KEY (`idReserva`, `IdFuncion`, `IdPelicula`, `IdSala`, `IdButaca`),
  INDEX `AK_Reservas_IdReserva` (`idReserva` ASC),
  INDEX `FK_Reservas_Funciones_idx` (`IdFuncion` ASC, `IdPelicula` ASC, `IdSala` ASC),
  INDEX `FK_Reservas_Butacas_idx` (`IdButaca` ASC, `IdSala` ASC),
  CONSTRAINT `FK_Reservas_Funciones`
      FOREIGN KEY (`IdFuncion`, `IdPelicula`, `IdSala`)
      REFERENCES `test_db`.`Funciones` (`idFuncion`, `IdPelicula`, `IdSala`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Reservas_Butacas`
    FOREIGN KEY (`IdButaca` , `IdSala`)
    REFERENCES `test_db`.`Butacas` (`idButaca` , `IdSala`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
