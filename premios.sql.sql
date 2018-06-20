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


-- Volcando estructura de base de datos para premios
CREATE DATABASE IF NOT EXISTS `premios` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_spanish_ci */;
USE `premios`;

-- Volcando estructura para tabla premios.persona
CREATE TABLE IF NOT EXISTS `persona` (
  `id_persona` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE latin1_spanish_ci NOT NULL,
  `acumulado` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_persona`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- Volcando datos para la tabla premios.persona: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `persona` DISABLE KEYS */;
INSERT INTO `persona` (`id_persona`, `nombre`, `acumulado`) VALUES
	(1, 'Antonio', 1070),
	(2, 'Pedro', 100),
	(3, 'Homer', 100),
	(4, 'Marta', 0);
/*!40000 ALTER TABLE `persona` ENABLE KEYS */;

-- Volcando estructura para tabla premios.premio
CREATE TABLE IF NOT EXISTS `premio` (
  `id_premio` int(11) NOT NULL,
  `id_persona` int(11) NOT NULL,
  `euros` int(11) NOT NULL,
  PRIMARY KEY (`id_premio`),
  KEY `FK_premio_persona` (`id_persona`),
  CONSTRAINT `FK_premio_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- Volcando datos para la tabla premios.premio: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `premio` DISABLE KEYS */;
INSERT INTO `premio` (`id_premio`, `id_persona`, `euros`) VALUES
	(1, 1, 1070),
	(2, 2, 100),
	(3, 3, 100),
	(4, 4, 900);
/*!40000 ALTER TABLE `premio` ENABLE KEYS */;

-- Volcando estructura para disparador premios.euros
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `euros` AFTER UPDATE ON `premio` FOR EACH ROW BEGIN
UPDATE persona
set acumulado=acumulado+new.euros
where euros=new.euros;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador premios.premios
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `premios` AFTER INSERT ON `premio` FOR EACH ROW BEGIN
UPDATE persona
set acumulado=acumulado+new.euros
where id_persona=new.id_persona;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador premios.premio_after_delete
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `premio_after_delete` AFTER DELETE ON `premio` FOR EACH ROW BEGIN
UPDATE persona
set acumulado=acumulado-old.euros
where id_persona=old.id_persona;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
