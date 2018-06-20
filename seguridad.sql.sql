-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.1.28-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win32
-- HeidiSQL Versión:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Volcando estructura de base de datos para seguridad
CREATE DATABASE IF NOT EXISTS `seguridad` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_spanish_ci */;
USE `seguridad`;

-- Volcando estructura para procedimiento seguridad.castigos
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `castigos`(
	IN `pieza` INT
)
BEGIN
declare castigo int;
set castigo=(select sum(pena_horas)
from detencion
where delincuente=pieza);

update delincuente set horas_castigo=castigo
where id=pieza;

END//
DELIMITER ;

-- Volcando estructura para tabla seguridad.comisaria
CREATE TABLE IF NOT EXISTS `comisaria` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL,
  `total_delitos` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- Volcando datos para la tabla seguridad.comisaria: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `comisaria` DISABLE KEYS */;
INSERT INTO `comisaria` (`id`, `nombre`, `total_delitos`) VALUES
	(1, 'Vallecas', 2),
	(2, 'Carabanchel', 1),
	(3, 'Coslada', 0),
	(4, 'Vicálvaro', 0);
/*!40000 ALTER TABLE `comisaria` ENABLE KEYS */;

-- Volcando estructura para procedimiento seguridad.datos
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `datos`(
	IN `comis` INT
)
BEGIN
declare datos int;
set datos=(select count(*)
from comisaria join policia join detencion
on comisaria.id=policia.comisaria and policia.id=detencion.policia
where comisaria.id=comis);

update comisaria set total_delitos=datos
where id=comis;
END//
DELIMITER ;

-- Volcando estructura para tabla seguridad.delincuente
CREATE TABLE IF NOT EXISTS `delincuente` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE latin1_spanish_ci NOT NULL,
  `horas_castigo` int(11) NOT NULL DEFAULT '0',
  `nacionalidad` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_delincuente_nacion` (`nacionalidad`),
  CONSTRAINT `FK_delincuente_nacion` FOREIGN KEY (`nacionalidad`) REFERENCES `nacion` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- Volcando datos para la tabla seguridad.delincuente: ~5 rows (aproximadamente)
/*!40000 ALTER TABLE `delincuente` DISABLE KEYS */;
INSERT INTO `delincuente` (`id`, `nombre`, `horas_castigo`, `nacionalidad`) VALUES
	(1, 'El vaquilla', 0, 1),
	(2, 'El Torete', 0, 1),
	(3, 'El Dioni', 0, 1),
	(4, 'M.Rajoy', 0, 1),
	(5, 'Laurent', 0, 2);
/*!40000 ALTER TABLE `delincuente` ENABLE KEYS */;

-- Volcando estructura para tabla seguridad.delito
CREATE TABLE IF NOT EXISTS `delito` (
  `id` int(11) NOT NULL,
  `tipo` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL,
  `total` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- Volcando datos para la tabla seguridad.delito: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `delito` DISABLE KEYS */;
INSERT INTO `delito` (`id`, `tipo`, `total`) VALUES
	(1, 'Tenencia de armas', 3),
	(2, 'Apropiación de fondos', 0);
/*!40000 ALTER TABLE `delito` ENABLE KEYS */;

-- Volcando estructura para procedimiento seguridad.delitos
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `delitos`(
	IN `id_delito` INT
)
BEGIN
declare detenciones int;
set detenciones=(select count(*) from detencion where delito=id_delito);

update delito set total=detenciones
where id=id_delito;

END//
DELIMITER ;

-- Volcando estructura para tabla seguridad.detencion
CREATE TABLE IF NOT EXISTS `detencion` (
  `policia` int(11) NOT NULL,
  `delito` int(11) NOT NULL DEFAULT '1',
  `delincuente` int(11) NOT NULL,
  `pena_horas` int(11) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `FK_detencion_policia` (`policia`),
  KEY `FK_detencion_delincuente` (`delincuente`),
  KEY `FK_detencion_delito` (`delito`),
  CONSTRAINT `FK_detencion_delincuente` FOREIGN KEY (`delincuente`) REFERENCES `delincuente` (`id`),
  CONSTRAINT `FK_detencion_delito` FOREIGN KEY (`delito`) REFERENCES `delito` (`id`),
  CONSTRAINT `FK_detencion_policia` FOREIGN KEY (`policia`) REFERENCES `policia` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- Volcando datos para la tabla seguridad.detencion: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `detencion` DISABLE KEYS */;
INSERT INTO `detencion` (`policia`, `delito`, `delincuente`, `pena_horas`, `id`) VALUES
	(2, 1, 3, 5, 1),
	(2, 1, 2, 4, 2),
	(1, 1, 2, 9, 3);
/*!40000 ALTER TABLE `detencion` ENABLE KEYS */;

-- Volcando estructura para función seguridad.detenciones
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `detenciones`(
	`id_poli` INT
) RETURNS int(11)
BEGIN

declare det int;
set det=(select count(*)
from detencion
where policia=id_poli);
return det;

END//
DELIMITER ;

-- Volcando estructura para tabla seguridad.nacion
CREATE TABLE IF NOT EXISTS `nacion` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE latin1_spanish_ci NOT NULL,
  `total_delitos` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- Volcando datos para la tabla seguridad.nacion: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `nacion` DISABLE KEYS */;
INSERT INTO `nacion` (`id`, `nombre`, `total_delitos`) VALUES
	(1, 'España', 3),
	(2, 'Francia', 0),
	(3, 'Italia', 0),
	(4, 'Portugal', 0);
/*!40000 ALTER TABLE `nacion` ENABLE KEYS */;

-- Volcando estructura para procedimiento seguridad.naciones
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `naciones`(
	IN `nac` INT
)
BEGIN

declare pais int;
set pais=(select count(*)
from detencion natural join delincuente
where delincuente.nacionalidad=nac);

update nacion set total_delitos=pais
where id=nac;


END//
DELIMITER ;

-- Volcando estructura para tabla seguridad.policia
CREATE TABLE IF NOT EXISTS `policia` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE latin1_spanish_ci DEFAULT NULL,
  `comisaria` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_policia_comisaria` (`comisaria`),
  CONSTRAINT `FK_policia_comisaria` FOREIGN KEY (`comisaria`) REFERENCES `comisaria` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- Volcando datos para la tabla seguridad.policia: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `policia` DISABLE KEYS */;
INSERT INTO `policia` (`id`, `nombre`, `comisaria`) VALUES
	(1, 'Chuck Norris', 2),
	(2, 'Jackie Chan', 1),
	(3, 'Silvester Stalone', 1);
/*!40000 ALTER TABLE `policia` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
