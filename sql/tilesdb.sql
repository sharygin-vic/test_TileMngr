/* SQL Manager Lite for MySQL                              5.6.3.49012 */
/* ------------------------------------------------------------------- */
/* Host     : localhost                                                */
/* Port     : 3306                                                     */
/* Database : tilesdb                                                  */


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES 'utf8' */;

SET FOREIGN_KEY_CHECKS=0;

DROP DATABASE IF EXISTS `tilesdb`;

CREATE DATABASE `tilesdb`
    CHARACTER SET 'utf8'
    COLLATE 'utf8_general_ci';

USE `tilesdb`;

/* Structure for the `tile` table : */

CREATE TABLE `tile` (
  `id` INTEGER(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY USING BTREE (`id`),
  UNIQUE KEY `id_UNIQUE` USING BTREE (`id`)
) ENGINE=InnoDB
AUTO_INCREMENT=38 CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
;

/* Data for the `tile` table  (LIMIT 0,500) */

INSERT INTO `tile` (`id`, `name`) VALUES
  (3,'wewe'),
  (4,'ghxfdjhgm,hj'),
  (6,'lkkhkhvhmvb'),
  (7,'111'),
  (25,'4refef'),
  (26,'2ee3'),
  (27,'121212'),
  (28,'999'),
  (29,'888'),
  (30,'777'),
  (32,'5555'),
  (33,'4444'),
  (36,'1111'),
  (37,'kjbhhb');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;