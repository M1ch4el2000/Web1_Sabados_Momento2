CREATE DATABASE reclutamiento;
GO

USE reclutamiento;
GO
--UNSC (United Nations Space Command o en español Comando Espacial de las Naciones Unidas)--


--Creamos las distintas ramas del UNSC
CREATE TABLE ramas_unsc(
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR (40) NOT NULL UNIQUE,
    descripcion VARCHAR(150) NOT NULL
);
--Oficina de Inteligencia Naval (ONI) y las Tropas de Choque de Descenso Orbital (ODST)
--
CREATE TABLE divisiones_especiales(
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR (35) NOT NULL UNIQUE,
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('ONI', 'ODST')), --Solo recibe ambas divisiones especiales ONI y ODST
    cupo_anual INT DEFAULT 10 NOT NULL
);

CREATE TABLE unsc(
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_unidad VARCHAR (50) NOT NULL UNIQUE,
    base VARCHAR (50) NOT NULL DEFAULT'No se asigno una base',
    ramas_unsc_id INT NOT NULL,
    CONSTRAINT unsc_ramas_unsc_fk FOREIGN KEY (ramas_unsc_id) REFERENCES ramas_unsc(id)
);

CREATE TABLE entidad(
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR (50) NOT NULL UNIQUE,
    ciudad VARCHAR (50) NOT NULL,
    unsc_id INT NOT NULL,
    CONSTRAINT entidad_unsc_fk FOREIGN KEY (unsc_id) REFERENCES unsc(id)
);

CREATE TABLE recluta(
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50)NOT NULL,
    edad INT NOT NULL CHECK (edad >= 18), --Validamos que la edad no sea menor 
    peso DECIMAL(5,2) NOT NULL,--Lo medimos en KG porque somos LATAM (5,2) significa que 5 hay digitos de los cuales 2 son decimales
    altura DECIMAL (3,2) NOT NULL,--En metros, no en pies ni pulgadas(3,2) significa que hay 3 digitos de los cuales 2 son decimales
    ramas_unsc_id int, 
    CONSTRAINT ramas_unsc_fk FOREIGN KEY (ramas_unsc_id) REFERENCES ramas_unsc(id)
);

CREATE TABLE apto_division_especial(
    id INT IDENTITY(1,1) PRIMARY KEY,
    apto_servicio BIT NOT NULL,
    recluta_id INT NOT NULL,
    divisiones_especiales_id INT NOT NULL,
    CONSTRAINT apto_recluta_fk FOREIGN KEY (recluta_id) REFERENCES recluta(id),
    CONSTRAINT apto_division_especial_fk FOREIGN KEY (divisiones_especiales_id) REFERENCES divisiones_especiales(id),
    CONSTRAINT apto_recluta_division_uq UNIQUE (recluta_id, divisiones_especiales_id)
);

    GO

