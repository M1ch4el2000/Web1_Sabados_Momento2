CREATE DATABASE reclutamiento;
GO

USE reclutamiento;
GO

CREATE TABLE ramas_unsc(
    id INT IDENTITY(1,1) PRIMARY KEY,
    armada VARCHAR(50),
    cuerpo_marines VARCHAR(50),
    ejercito VARCHAR(50),
    fuerza_aerea VARCHAR(50),
    cuerpo_spartan VARCHAR(50),
    divisiones_especiales VARCHAR(50)
);

CREATE TABLE divisiones_especiales(
    id INT IDENTITY(1,1) PRIMARY KEY,
    oni VARCHAR(50),
    odst VARCHAR(50)
);

CREATE TABLE unsc(
    id INT IDENTITY(1,1) PRIMARY KEY,
    ramas_unsc_id INT,
    CONSTRAINT ramas_unsc_fk FOREIGN KEY (ramas_unsc_id) REFERENCES ramas_unsc(id)
);

CREATE TABLE recluta(
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    edad INT,
    peso DECIMAL,
    altura DECIMAL,
    CONSTRAINT ramas_unsc_fk FOREIGN KEY (ramas_unsc_id) REFERENCES ramas_unsc(id)
);

CREATE TABLE apto_division_especial(
    id INT IDENTITY(1,1) PRIMARY KEY,
    apto_servicio BIT NOT NULL,
    recluta_id INT,
    divisiones_especiales_id INT,
    CONSTRAINT recluta_fk FOREIGN KEY (recluta_id) REFERENCES recluta(id),
    CONSTRAINT division_especial_fk FOREIGN KEY (divisiones_especiales_id) REFERENCES divisiones_especiales(id)
);

CREATE TABLE entidad(
    id INT IDENTITY(1,1) PRIMARY KEY,
    unsc_id INT,
    CONSTRAINT unsc_fk FOREIGN KEY (unsc_id) REFERENCES unsc(id)
);