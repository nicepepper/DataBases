CREATE DATABASE IF NOT EXISTS lab3 CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE iF NOT EXISTS `lab3`.`cinema` (
  `id_cinema` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `addres` VARCHAR(255) NOT NULL,
  `opening_time` DATETIME NOT NULL,
  `closing_time` DATETIME NOT NULL,
  `number_of_hallse` TINYINT(127) NOT NULL,
  PRIMARY KEY (`id_cinema`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `lab3`.`hall` (
  `id_hall` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_cinema` INT UNSIGNED NOT NULL,
  `number` TINYINT(127) NOT NULL,
  PRIMARY KEY (`id_hall`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `lab3`.`session` (
  `id_session` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_film` INT UNSIGNED NOT NULL,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NOT NULL,
  `cost` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_session`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `lab3`.`film` (
  `id_film` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_director` INT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `discriprion` TEXT NOT NULL,
  `duration` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_film`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `lab3`.`director` (
  `id_director` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(150) NOT NULL,
  `last_name` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id_director`))
ENGINE = InnoDB;