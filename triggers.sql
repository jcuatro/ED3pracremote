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


-- Volcando estructura de base de datos para examentriggers
CREATE DATABASE IF NOT EXISTS `examentriggers` /*!40100 DEFAULT CHARACTER SET ucs2 COLLATE ucs2_spanish_ci */;
USE `examentriggers`;

-- Volcando estructura para tabla examentriggers.contrato
CREATE TABLE IF NOT EXISTS `contrato` (
  `id_empleado` int(11) NOT NULL,
  `id_dpto` int(11) NOT NULL,
  `sueldo` int(11) NOT NULL,
  PRIMARY KEY (`id_empleado`,`id_dpto`),
  KEY `FK_contrato_departamento` (`id_dpto`),
  CONSTRAINT `FK_contrato_departamento` FOREIGN KEY (`id_dpto`) REFERENCES `departamento` (`id_dpto`),
  CONSTRAINT `FK_contrato_empleado` FOREIGN KEY (`id_empleado`) REFERENCES `empleado` (`id_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2 COLLATE=ucs2_spanish_ci;

-- Volcando datos para la tabla examentriggers.contrato: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `contrato` DISABLE KEYS */;
INSERT INTO `contrato` (`id_empleado`, `id_dpto`, `sueldo`) VALUES
	(1, 1, 1100),
	(2, 1, 1210);
/*!40000 ALTER TABLE `contrato` ENABLE KEYS */;

-- Volcando estructura para tabla examentriggers.departamento
CREATE TABLE IF NOT EXISTS `departamento` (
  `id_dpto` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE ucs2_spanish_ci DEFAULT NULL,
  `dispendio` int(11) DEFAULT '0',
  `total` int(11) DEFAULT '0',
  `media_hijos` int(11) DEFAULT '0',
  PRIMARY KEY (`id_dpto`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2 COLLATE=ucs2_spanish_ci;

-- Volcando datos para la tabla examentriggers.departamento: ~1 rows (aproximadamente)
/*!40000 ALTER TABLE `departamento` DISABLE KEYS */;
INSERT INTO `departamento` (`id_dpto`, `nombre`, `dispendio`, `total`, `media_hijos`) VALUES
	(1, 'marketing', 200, 500, 0);
/*!40000 ALTER TABLE `departamento` ENABLE KEYS */;

-- Volcando estructura para tabla examentriggers.empleado
CREATE TABLE IF NOT EXISTS `empleado` (
  `id_empleado` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE ucs2_spanish_ci DEFAULT NULL,
  `cantidad` int(11) DEFAULT '0',
  `hijos` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2 COLLATE=ucs2_spanish_ci;

-- Volcando datos para la tabla examentriggers.empleado: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `empleado` DISABLE KEYS */;
INSERT INTO `empleado` (`id_empleado`, `nombre`, `cantidad`, `hijos`) VALUES
	(1, 'Antonio', 200, 0),
	(2, 'Evaristo', 100, 2);
/*!40000 ALTER TABLE `empleado` ENABLE KEYS */;

-- Volcando estructura para disparador examentriggers.contrato1
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `contrato1` AFTER DELETE ON `contrato` FOR EACH ROW BEGIN
UPDATE departamento
set total=total-1
where id_dpto=old.id_empleado;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador examentriggers.contrato3
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `contrato3` AFTER INSERT ON `contrato` FOR EACH ROW BEGIN
UPDATE departamento
set dispendio=dispendio+new.sueldo
where id_dpto=new.id_dpto;

UPDATE empleado
set cantidad=cantidad+new.sueldo
where id_empleado=new.id_empleado;

UPDATE departamento
set total=total+1
where id_dpto=new.id_dpto;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador examentriggers.contrato4
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `contrato4` AFTER UPDATE ON `contrato` FOR EACH ROW BEGIN
UPDATE departamento
set dispendio=dispendio+new.sueldo-old.sueldo
where id_dpto=new.id_dpto;

UPDATE empleado
set cantidad=cantidad+new.sueldo-old.sueldo
where id_empleado=new.id_empleado;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador examentriggers.hijos2
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `hijos2` AFTER UPDATE ON `empleado` FOR EACH ROW BEGIN
DECLARE mediaHijos FLOAT;
select avg(hijos) into mediaHijos from departamento natural join contrato;
UPDATE departamento
set media_hijos=mediaHijos;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
