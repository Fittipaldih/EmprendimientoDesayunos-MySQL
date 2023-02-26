/*
Para el emprendimiento culinario de pastelería "Desayunos a Domicilio” se ha plasmado el siguiente modelo relacional: 
 
Producto (idProducto, Nombre, fecha_creacion, precio)   
Temas_Producidos (idTema, idProducto)   
Composición (idProducto, idComponente, vencimiento, cantidad_componente)   
Componente (idComponente, Descripción, idColorPredominante, esPersonalizado, costo)   
Receta (idComponente, paso, idIngrediente, medida, cantidad, elaboración)   
Ingrediente (idIngrediente, nombre)   
Tema (idTema, Nombre, color1, color2, color3)   
Color (idColor, Nombre)  

Realizar la creacion de la Base de Datos y las consultas necesarias para el correcto funcionamiento del emprendimiento

 CREACION DE BD Y TABLAS */
CREATE SCHEMA IF NOT EXISTS DesayunosADomicilio;
USE DesayunosADomicilio;

CREATE TABLE Producto(
	IdProducto INT PRIMARY KEY auto_increment,
    Nombre VARCHAR(25) NOT NULL UNIQUE,
    FechaCreacion DATE NOT NULL,
    Precio DECIMAL(7,2)
);
CREATE TABLE Color(
	IdColor INT PRIMARY KEY auto_increment,
    Nombre VARCHAR(25) NOT NULL UNIQUE
);
CREATE TABLE Ingrediente(
	IdIngrediente INT PRIMARY KEY auto_increment,
    Nombre VARCHAR(25) NOT NULL UNIQUE
);
CREATE TABLE Tema(
	IdTema INT PRIMARY KEY auto_increment,
    Nombre VARCHAR(25) NOT NULL UNIQUE,
    Color1 INT NOT NULL REFERENCES Color(IdColor),
    Color2 INT NULL REFERENCES Color(IdColor),
    Color3 INT NULL REFERENCES Color(IdColor)
);
CREATE TABLE Tema_Producido(
	IdTema INT references Tema(IdTema),
    IdProducto INT REFERENCES Producto(IdProducto),
    PRIMARY KEY(IdTema, IdProducto)
);
CREATE TABLE Componente(
	IdComponente INT PRIMARY KEY auto_increment,
    Descripcion VARCHAR(25) NOT NULL UNIQUE,
    IdColorPredominante INT REFERENCES Color(IdColor),
    EsPersonalizado boolean NOT NULL, -- Tambien podria usarse => TINYINT(1) por si cambian las condiciones a 3
	Costo DECIMAL(7,2) NOT NULL
);
CREATE TABLE Composicion (
	IdProducto int NOT NULL REFERENCES Producto(idProducto),
    IdComponente int NOT NULL references Componente(IdComponente),
    Vencimiento date NOT NULL,
    CantidadComponente TINYINT DEFAULT 1,
    CONSTRAINT PK_Composicion PRIMARY KEY (IdProducto, IdComponente)
);
CREATE TABLE Receta (
	IdIngrediente int NOT NULL REFERENCES Ingrediente(IdIngrediente),
    IdComponente int NOT NULL references Componente(IdComponente),
    Paso TINYINT NOT NULL,
    Medida DECIMAL(7,2) DEFAULT 1,
    Cantidad TINYINT DEFAULT 1,
    Elaboracion TEXT,
    CONSTRAINT PK_Receta PRIMARY KEY (IdIngrediente, IdComponente, Paso)
);

/*** EJERCICIOS ABM / CRUD ***/
-- 1:
INSERT INTO Producto(Nombre, FechaCreacion, Precio)
VALUES 	('Box de Cumpleaños', '2022-11-05', 5399.99),
		('Canasta Feliz Aniversario', '2022-11-05', 4499.99);
    
-- 2: Eliminar todas las recetas del componente llamado “Alfajor de maicena” que tiene id=4
DELETE FROM Receta
WHERE IdComponente = 4;
-- Si no sabriamos el ID :
DELETE FROM Receta
WHERE EXISTS(SELECT 1 FROM Componente
			WHERE Componente.IdComponente = Receta.IdComponente
			AND Nombre like '%Alfajor de Maicena%');
            
-- 3. Actualizar todos los productos que tienen tema de “Unicornios“ a “Alicornios”.
UPDATE Tema_Producido 
SET IdTema = 4 -- 'Alicornio'
WHERE IdTema = 3; -- 'Unicornio'
UPDATE Tema_Producido 
SET IdTema = (
	SELECT IdTema FROM Tema 
    WHERE Nombre like 'Alicornio')
WHERE IdTema = (
	SELECT IdTema FROM Tema 
    WHERE Nombre like 'Unicornio');

/*** DML ***/
-- 4. Obtener todas las recetas por componente, paso e ingrediente.
SELECT C.Nombre, R.Paso, I.Nombre, 
	 R.Cantidad, R.Medida, R.Elaboracion
FROM Receta R
JOIN Componente C ON C.IdComponente = R.IdComponente
JOIN Ingrediente I ON I.IdIngrediente = R.IdIngrediente
ORDER BY C.Nombre, R.Paso;

-- 5. Listar todos los productos que sean deslactosados o sin lactosa. 
-- (Se entiende que contengan ingredientes “sin lactosa” o “deslactosado” O bien que NO contengan ingredientes que sean leche o derivados).
SELECT P.* FROM Producto P
JOIN Composicion CP ON CP.IdProducto = P.IdProducto
WHERE EXISTS (SELECT 1 FROM Receta R
			JOIN Ingrediente I ON I.IdIngrediente = R.Ingrediente
			 WHERE R.IdComponente = CP.IdComponente
			 AND (I.Nombre like '%sin lactosa%' OR I.Nombre like '%deslactosado%'))
AND NOT EXISTS( SELECT 1 FROM Receta R
				JOIN Ingrediente I ON I.IdIngrediente = R.Ingrediente
				WHERE R.IdComponente = CP.IdComponente
				AND (I.Nombre like '%leche%' OR I.Nombre like '%queso%' OR I.Nombre like '%yogurt%')
);
-- 6. Mostrar todos los productos que se fabrican, con la cantidad de Componentes en cada Producto
SELECT P.Nombre AS Producto, COUNT(CP.IdComponente) AS ComponenteID, SUM(CP.CantidadComponente) as ComponenteCantidad
FROM Producto P
JOIN Composicion CP ON CP.IdProducto = P.IdProducto
GROUP BY P.IdProducto, P.Nombre;

-- 7. ¿Cuáles son los productos que se elaboran con recetas que usan todos los ingredientes? Componente que tienen todos los ingredientes
SELECT C.*
FROM Componente C
WHERE NOT EXISTS (SELECT 1 
				FROM Ingrediente I
				WHERE NOT EXISTS (SELECT 1 
								FROM Receta R
								WHERE R.IdComponente = C.IdComponente 
								AND R.IdIngrediente = I.IdIngrediente)
);
-- Con Producto
SELECT P.*
FROM Producto P
WHERE NOT EXISTS (	SELECT 1 FROM Ingrediente I
					WHERE NOT EXISTS (	SELECT 1 
										FROM Composicion C
										JOIN Receta R ON R.IdComponente = C.IdComponente
										WHERE C.IdProducto = P.IdProducto 
										AND R.IdIngrediente = I.IdIngrediente)
);

-- 8. ¿Cuáles son las recetas con más alto costo? Componentes con más alto costo
SELECT C.*
FROM Componente C
WHERE C.costo = (SELECT MAX(Cmax.costo) 
				FROM Componente Cmax);
                
-- Productos de mayor costo: DISTINTAS FORMAS DE HACERLO:
SELECT P.Nombre, SUM(C.Costo * CP.CantidadComponente) as costoTotal
FROM Producto P
JOIN Composicion CP ON CP.IdProducto = P.IdProducto
JOIN Componente C ON C.IdComponente = CP.IdComponente
GROUP BY P.IdProducto, P.Nombre, P.Precio
HAVING SUM(C.Costo * CP.CantidadComponente) = (SELECT MAX(paraMax.costoTotal) 
												FROM (	SELECT P2.Nombre, SUM(C2.Costo * CP2.CantidadComponente) as costoTotal
														FROM Producto P2
														JOIN Composicion CP2 ON CP2.IdProducto = P2.IdProducto
														JOIN Componente C2 ON C2.IdComponente = CP2.IdComponente
														GROUP BY P2.IdProducto, P2.Nombre, P2.Precio) paraMax
);
-- ---------------------------------------------------------------------------------------------------------------------------
SELECT P.*
FROM Producto P
WHERE C.costo = (SELECT MAX(Cmax.costo) 
				FROM Componente Cmax);

SELECT P.Nombre, P.Precio, SUM(C.Costo) as costoTotal, 	P.Precio - SUM(C.Costo) as Ganancia
FROM Producto P
JOIN Composicion CP ON CP.IdProducto = P.IdProducto
JOIN Componente C ON C.IdComponente = CP.IdComponente
GROUP BY P.IdProducto, P.Nombre, P.Precio;

-- 9. ¿Qué productos temáticos (nombre de producto y nombre de tema) tienen componentes personalizados, y su color predominante está entre los colores del tema asociado?
SELECT P.Nombre, T.Nombre
FROM Producto P
JOIN Tema_Producido TP ON TP.IdProducto = P.IdProducto
JOIN Tema T ON T.IdTema = TP.IdTema
WHERE EXISTS (SELECT 1 
			FROM Componente C
			JOIN Composicion CP ON CP.IdComponente = C.IdComponente
			WHERE CP.IdProducto = P.IdProducto
			AND C.EsPersonalizado = TRUE
			AND C.IdColorPredominante IS NOT NULL
			AND C.IdColorPredominante IN(T.Color1, T.Color2, T.Color3)
);

-- 10. Mostrar la ganancia que se obtiene por producto. (Precio Total - Costos de fabricacion)
SELECT P.Nombre, P.Precio, SUM(C.Costo * CP.CantidadComponente) as costoTotal, P.Precio - SUM(C.Costo * CP.CantidadComponente) as Ganancia
FROM Producto P
JOIN Composicion CP ON CP.IdProducto = P.IdProducto
JOIN Componente C ON C.IdComponente = CP.IdComponente
GROUP BY P.IdProducto, P.Nombre, P.Precio