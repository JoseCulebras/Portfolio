-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`PERMISOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PERMISOS` (
  `id_permiso` INT NOT NULL AUTO_INCREMENT,
  `descripcion` TEXT NULL,
  PRIMARY KEY (`id_permiso`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`ROL`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ROL` (
  `id_rol` INT NOT NULL AUTO_INCREMENT,
  `nombre_rol` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_rol`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`ROL_has_PERMISOS` (Relación Muchos a Muchos)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ROL_has_PERMISOS` (
  `id_rol` INT NOT NULL,
  `id_permiso` INT NOT NULL,
  PRIMARY KEY (`id_rol`, `id_permiso`),
  CONSTRAINT `fk_rol` FOREIGN KEY (`id_rol`) REFERENCES `mydb`.`ROL` (`id_rol`),
  CONSTRAINT `fk_permiso` FOREIGN KEY (`id_permiso`) REFERENCES `mydb`.`PERMISOS` (`id_permiso`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`USUARIO`
-- -----------------------------------------------------
-- Se añade campo 'tipo' para distinguir entre psicólogo y cliente
CREATE TABLE IF NOT EXISTS `mydb`.`USUARIO` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre_usuario` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `tipo` ENUM('psicologo', 'cliente') NOT NULL,
  `id_rol` INT NOT NULL,
  PRIMARY KEY (`id_usuario`),
  CONSTRAINT `fk_usuario_rol` FOREIGN KEY (`id_rol`) REFERENCES `mydb`.`ROL` (`id_rol`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`PSICÓLOGO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PSICÓLOGO` (
  `id_psicologo` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido1` VARCHAR(45) NOT NULL,
  `apellido2` VARCHAR(45) NULL,
  `horarios` VARCHAR(45) NOT NULL,
  `especialidad` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_psicologo`),
  CONSTRAINT `fk_psicologo_usuario` FOREIGN KEY (`id_psicologo`) REFERENCES `mydb`.`USUARIO` (`id_usuario`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`PACIENTE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PACIENTE` (
  `id_paciente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido1` VARCHAR(45) NOT NULL,
  `apellido2` VARCHAR(45) NULL,
  `fecha_baja` DATE NULL,
  `fecha_alta` DATE NOT NULL,
  `diagnostico` VARCHAR(255) NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `edad` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_paciente`),
  CONSTRAINT `fk_paciente_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `mydb`.`USUARIO` (`id_usuario`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`CITA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`CITA` (
  `id_cita` INT NOT NULL AUTO_INCREMENT,
  `estado_de_cita` VARCHAR(45) NOT NULL,
  `fecha_hora` DATETIME NOT NULL,
  `id_paciente` INT NOT NULL,
  `id_psicologo` INT NOT NULL,
  PRIMARY KEY (`id_cita`),
  CONSTRAINT `fk_cita_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `mydb`.`PACIENTE` (`id_paciente`),
  CONSTRAINT `fk_cita_psicologo` FOREIGN KEY (`id_psicologo`) REFERENCES `mydb`.`PSICÓLOGO` (`id_psicologo`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`SESIÓN`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`SESIÓN` (
  `id_sesion` INT NOT NULL AUTO_INCREMENT,
  `numero_de_sesion` INT NOT NULL, -- Diferente al ID
  `notas` TEXT NULL,
  `observaciones` TEXT NULL,
  `recomendaciones` TEXT NULL,
  `id_cita` INT NOT NULL,
  `id_psicologo` INT NOT NULL,
  PRIMARY KEY (`id_sesion`),
  UNIQUE INDEX `id_cita_UNIQUE` (`id_cita` ASC), -- Garantiza relación 1:1
  CONSTRAINT `fk_sesion_cita` FOREIGN KEY (`id_cita`) REFERENCES `mydb`.`CITA` (`id_cita`),
  CONSTRAINT `fk_sesion_psicologo` FOREIGN KEY (`id_psicologo`) REFERENCES `mydb`.`PSICÓLOGO` (`id_psicologo`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`PAGO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PAGO` (
  `id_pago` INT NOT NULL AUTO_INCREMENT,
  `metodo_pago` VARCHAR(45) NOT NULL,
  `monto_base` DECIMAL(10,2) NOT NULL,
  `iva_porcentaje` DECIMAL(5,2) DEFAULT 21.00,
  `monto_total` DECIMAL(10,2) NOT NULL,
  `fecha_de_pago` DATE NOT NULL,
  `id_cita` INT NOT NULL,
  PRIMARY KEY (`id_pago`),
  CONSTRAINT `fk_pago_cita` FOREIGN KEY (`id_cita`) REFERENCES `mydb`.`CITA` (`id_cita`))
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
