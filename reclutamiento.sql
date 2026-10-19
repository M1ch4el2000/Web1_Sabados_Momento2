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

--Utilizamos Alter table para modificar las tablas ya creadas

ALTER TABLE recluta
    ADD fecha_registro DATE NOT NULL
    CONSTRAINT recluta_fecha_registro_df DEFAULT (CAST(GETDATE() AS DATE));
 
ALTER TABLE recluta
    ADD estado VARCHAR(20) NOT NULL
    CONSTRAINT recluta_estado_df DEFAULT 'En evaluacion';
 
ALTER TABLE recluta 
    ADD entidad_id INT NULL;

GO
 
ALTER TABLE recluta
    ADD CONSTRAINT recluta_entidad_fk FOREIGN KEY (entidad_id) REFERENCES entidad(id);
 

ALTER TABLE apto_division_especial
    ADD fecha_evaluacion DATE NOT NULL
    CONSTRAINT apto_fecha_evaluacion_df DEFAULT (CAST(GETDATE() AS DATE));
 
ALTER TABLE apto_division_especial
    ADD puntaje INT NOT NULL
    CONSTRAINT apto_puntaje_df DEFAULT 0;
    
GO
 
ALTER TABLE apto_division_especial
    ADD CONSTRAINT apto_puntaje_ck CHECK (puntaje BETWEEN 0 AND 100);
GO


--Llenamos los datos con ayuda de la IA para que las tablas tengan 20 registros 

-- 20 ramas y cuerpos
INSERT INTO ramas_unsc (nombre, descripcion) VALUES
('Armada', 'Flota espacial de combate y transporte de la UNSC'),
('Cuerpo de Marines', 'Infanteria de asalto desplegada desde naves y estaciones'),
('Ejercito', 'Fuerzas terrestres de defensa y ocupacion de planetas'),
('Fuerza Aerea', 'Aeronaves de combate, apoyo cercano y transporte atmosferico'),
('Cuerpo Spartan', 'Soldados de elite sometidos a entrenamiento y mejoras especiales'),
('Divisiones Especiales', 'Unidades de inteligencia y choque orbital'),
('Cuerpo Medico', 'Atencion sanitaria y rescate de heridos en combate'),
('Cuerpo de Ingenieros', 'Construccion de bases, puentes y fortificaciones'),
('Inteligencia Naval', 'Recopilacion y analisis de informacion estrategica'),
('Comunicaciones y Cifrado', 'Redes de comunicacion y seguridad de mensajes'),
('Logistica y Suministros', 'Abastecimiento de municion, alimentos y repuestos'),
('Infanteria Ligera', 'Tropas de movilidad rapida y reconocimiento'),
('Caballeria Blindada', 'Vehiculos blindados y tanques de combate'),
('Artilleria Pesada', 'Apoyo de fuego de largo alcance'),
('Cuerpo de Pilotos de Caza', 'Pilotos de cazas espaciales y atmosfericos'),
('Fuerzas de Defensa Planetaria', 'Proteccion permanente de colonias exteriores'),
('Policia Militar', 'Orden interno y custodia de instalaciones militares'),
('Cuerpo de Cartografia', 'Mapeo de planetas y rutas de navegacion'),
('Ciberseguridad Militar', 'Defensa de sistemas informaticos y redes'),
('Guardia Colonial', 'Seguridad civil y militar en colonias jovenes');
 
-- 20 divisiones especiales: 10 ONI y 10 ODST
INSERT INTO divisiones_especiales (nombre, tipo, cupo_anual) VALUES
('ONI - Seccion Cero', 'ONI', 5),
('ONI - Seccion Uno', 'ONI', 8),
('ONI - Seccion Dos', 'ONI', 8),
('ONI - Seccion Tres', 'ONI', 6),
('ONI - Contrainteligencia', 'ONI', 10),
('ONI - Analisis de Amenazas', 'ONI', 12),
('ONI - Operaciones Encubiertas', 'ONI', 7),
('ONI - Criptoanalisis', 'ONI', 9),
('ONI - Investigacion Xenologica', 'ONI', 6),
('ONI - Guerra Psicologica', 'ONI', 5),
('ODST - 105 Batallon de Choque', 'ODST', 40),
('ODST - 7 Batallon de Choque', 'ODST', 35),
('ODST - 9 Batallon de Choque', 'ODST', 35),
('ODST - 12 Batallon de Choque', 'ODST', 30),
('ODST - 22 Batallon de Choque', 'ODST', 30),
('ODST - 36 Batallon de Choque', 'ODST', 28),
('ODST - 45 Batallon de Choque', 'ODST', 25),
('ODST - 58 Batallon de Choque', 'ODST', 25),
('ODST - 64 Batallon de Choque', 'ODST', 22),
('ODST - 91 Batallon de Choque', 'ODST', 20);
 
-- 20 unidades militares (las ramas 17 a 20 aun no tienen unidades)
INSERT INTO unsc (nombre_unidad, base, ramas_unsc_id) VALUES
('Primera Flota de Batalla', 'Estacion Cairo', 1),
('Segunda Flota de Reconocimiento', 'Base Lunar Alfa', 1),
('3ra Division de Marines', 'Base Kilimanjaro', 2),
('7ma Brigada de Marines', 'Fuerte Salvo', 2),
('12mo Regimiento de Infanteria', 'Base Nairobi Norte', 3),
('4to Batallon Blindado', 'Base Voi', 3),
('21er Escuadron de Caza', 'Base Aerea Sydney', 4),
('Programa Spartan-II Alfa', 'Instalacion Onyx', 5),
('Programa Spartan-III Gamma', 'Base Gamma Prime', 5),
('Direccion de Divisiones Especiales', 'Sede Cleveland', 6),
('Hospital Militar Central', 'Ginebra', 7),
('Batallon de Ingenieros 5', 'Base Trevelyan', 8),
('Oficina de Inteligencia Naval Norte', 'Estacion Reikiavik', 9),
('Centro de Cifrado Atlas', 'Base Lunar Beta', 10),
('Deposito Logistico Central', 'Puerto de Nueva Alejandria', 11),
('Compania de Infanteria Ligera 9', 'Base Harvest', 12),
('Escuadron Blindado Pegaso', 'Base Arcadia', 13),
('Bateria de Artilleria Titan', 'Fuerte Madrigal', 14),
('Academia de Pilotos Orion', 'Base Marte Olympus', 15),
('Fuerza de Defensa Planetaria Tribute', 'Tribute', 16);
 
-- 20 centros de reclutamiento
INSERT INTO entidad (nombre, ciudad, unsc_id) VALUES
('Centro de Reclutamiento Nueva Mombasa', 'Nueva Mombasa', 1),
('Centro de Reclutamiento Sydney', 'Sydney', 2),
('Centro de Reclutamiento Cleveland', 'Cleveland', 10),
('Centro de Reclutamiento Voi', 'Voi', 6),
('Centro de Reclutamiento Reikiavik', 'Reikiavik', 13),
('Centro de Reclutamiento Ginebra', 'Ginebra', 11),
('Centro de Reclutamiento Nueva Alejandria', 'Nueva Alejandria', 15),
('Centro de Reclutamiento Chicago', 'Chicago', 3),
('Centro de Reclutamiento Tokio', 'Tokio', 7),
('Centro de Reclutamiento Buenos Aires', 'Buenos Aires', 4),
('Centro de Reclutamiento Medellin', 'Medellin', 8),
('Centro de Reclutamiento Nairobi', 'Nairobi', 5),
('Centro de Reclutamiento Lisboa', 'Lisboa', 12),
('Centro de Reclutamiento Vancouver', 'Vancouver', 14),
('Centro de Reclutamiento Singapur', 'Singapur', 16),
('Centro de Reclutamiento El Cairo', 'El Cairo', 17),
('Centro de Reclutamiento Oslo', 'Oslo', 18),
('Centro de Reclutamiento Lima', 'Lima', 19),
('Centro de Reclutamiento Madrid', 'Madrid', 9),
('Centro de Reclutamiento Ciudad de Mexico', 'Ciudad de Mexico', 20);
 
-- 22 reclutas (el estado se omite a proposito: toma el DEFAULT 'En evaluacion')
INSERT INTO recluta (nombre, apellido, edad, peso, altura, ramas_unsc_id, entidad_id, fecha_registro) VALUES
('Carlos', 'Mendoza', 24, 82.50, 1.84, 5, 1, '2025-11-03'),
('Valentina', 'Rojas', 22, 61.00, 1.68, 2, 2, '2025-11-17'),
('Andres', 'Gutierrez', 27, 78.20, 1.80, 6, 3, '2025-12-01'),
('Camila', 'Herrera', 23, 58.40, 1.65, 4, 4, '2025-12-09'),
('Santiago', 'Vargas', 25, 90.10, 1.88, 2, 5, '2026-01-05'),
('Daniela', 'Castro', 21, 55.80, 1.62, 3, 6, '2026-01-12'),
('Mateo', 'Ramirez', 29, 85.30, 1.86, 6, 7, '2026-01-20'),
('Sofia', 'Morales', 26, 63.70, 1.70, 9, 8, '2026-02-02'),
('Juan Pablo', 'Ortiz', 24, 88.60, 1.90, 5, 9, '2026-02-09'),
('Laura', 'Jimenez', 28, 66.20, 1.72, 1, 10, '2026-02-16'),
('Sebastian', 'Pineda', 30, 92.40, 1.91, 3, 11, '2026-03-02'),
('Isabella', 'Cardona', 20, 57.90, 1.64, 12, 12, '2026-03-10'),
('Felipe', 'Restrepo', 26, 80.00, 1.83, 2, 13, '2026-03-23'),
('Mariana', 'Osorio', 31, 64.50, 1.69, 19, 14, '2026-04-06'),
('Nicolas', 'Salazar', 23, 77.80, 1.79, 6, 15, '2026-04-13'),
('Juliana', 'Arango', 25, 59.30, 1.66, 15, 16, '2026-04-27'),
('Daniel', 'Cano', 27, 95.20, 1.93, 5, 17, '2026-05-04'),
('Natalia', 'Duque', 22, 60.40, 1.67, 13, 18, '2026-05-18'),
('Alejandro', 'Munoz', 33, 83.90, 1.85, 1, 19, '2026-06-01'),
('Paula', 'Zapata', 24, 62.10, 1.71, 7, 20, '2026-06-15'),
('Esteban', 'Giraldo', 28, 87.00, 1.87, 3, 5, '2026-07-06'),
('Carolina', 'Betancur', 26, 64.00, 1.70, 8, 11, '2026-08-03');
 
-- 20 evaluaciones (los reclutas 19 a 22 aun no han sido evaluados).
-- Todas se cargan como aptas de forma provisional; el UPDATE de mas abajo
-- corrige el resultado segun el puntaje.
INSERT INTO apto_division_especial (apto_servicio, recluta_id, divisiones_especiales_id, fecha_evaluacion, puntaje) VALUES
(1, 1, 12, '2026-01-15', 88),
(1, 2, 11, '2026-01-22', 72),
(1, 3, 3,  '2026-02-03', 55),
(1, 4, 15, '2026-02-10', 91),
(1, 5, 16, '2026-02-18', 67),
(1, 6, 13, '2026-03-02', 48),
(1, 7, 1,  '2026-03-09', 79),
(1, 8, 18, '2026-03-16', 83),
(1, 9, 12, '2026-03-25', 95),
(1, 10, 20, '2026-04-01', 62),
(1, 11, 14, '2026-04-08', 58),
(1, 12, 17, '2026-04-20', 74),
(1, 13, 11, '2026-05-04', 86),
(1, 14, 19, '2026-05-12', 69),
(1, 15, 2,  '2026-05-19', 52),
(1, 16, 16, '2026-06-02', 77),
(1, 17, 13, '2026-06-10', 90),
(1, 18, 15, '2026-06-23', 64),
(1, 3, 11,  '2026-07-06', 81),
(1, 7, 12,  '2026-07-14', 93);
GO

    --Se actualiza el puntaje para que se evalue un puntaje mayor a 60 
UPDATE apto_division_especial
SET apto_servicio = 0
WHERE puntaje < 60;

    --Los reclutas que al menos tengan una evaliacion pasada seran aptos. 
UPDATE recluta
SET estado = 'Apto'
Where id IN(SELECT recluta_id FROM apto_division_especial WHERE apto_servicio = 1);

    --Si no tienen una evaluacion padasas seran no aptos
UPDATE recluta
SET estado = 'No apto'
WHERE id IN (SELECT recluta_id FROM apto_division_especial)
  AND id NOT IN (SELECT recluta_id FROM apto_division_especial WHERE apto_servicio = 1);


  --Se aumenta en 5 el cupo anual de ODST
UPDATE divisiones_especiales
SET cupo_anual = cupo_anual + 5
WHERE tipo = 'ODST';
GO

-- Pregunta: Que ramas tienen al menos 2 reclutas y cual es la edad promedio en cada una?
SELECT
    ru.nombre AS rama,
    COUNT(r.id) AS total_reclutas,
    AVG(r.edad * 1.0) AS edad_promedio
FROM recluta r
INNER JOIN ramas_unsc ru 
ON ru.id = r.ramas_unsc_id
GROUP BY ru.nombre
HAVING COUNT(r.id) >= 2
ORDER BY total_reclutas DESC;

-- Pregunta: Cual es el puntaje promedio de las evaluaciones de ONI frente a ODST?
SELECT
    de.tipo,
    COUNT(a.id) AS total_evaluaciones,
    AVG(a.puntaje * 1.0) AS puntaje_promedio
FROM apto_division_especial a
INNER JOIN divisiones_especiales de 
ON de.id = a.divisiones_especiales_id
GROUP BY de.tipo
HAVING COUNT(a.id) >= 3;

-- Pregunta: Que reclutas aun no han sido evaluados y cuantos dias llevan esperando?
SELECT
    r.nombre,
    r.apellido,
    r.fecha_registro,
    DATEDIFF(DAY, r.fecha_registro, GETDATE()) AS dias_en_espera
FROM recluta r
LEFT JOIN apto_division_especial a 
ON a.recluta_id = r.id
WHERE a.id IS NULL
ORDER BY dias_en_espera DESC;

-- Pregunta: En 2026, cuantas evaluaciones y cuantos aptos hubo por mes? (solo meses con 3 o mas evaluaciones)
SELECT
    MONTH(fecha_evaluacion) AS mes,
    COUNT(*) AS total_evaluaciones,
    SUM(CAST(apto_servicio AS INT)) AS total_aptos
FROM apto_division_especial
WHERE YEAR(fecha_evaluacion) = 2026
GROUP BY MONTH(fecha_evaluacion)
HAVING COUNT(*) >= 3
ORDER BY mes;

-- Pregunta: Cuantos reclutas hay en cada estado y cual es su peso y altura promedio?
SELECT
    estado,
    COUNT(*) AS total_reclutas,
    AVG(peso) AS peso_promedio_kg,
    AVG(altura) AS altura_promedio_m
FROM recluta
GROUP BY estado
HAVING COUNT(*) >= 3;