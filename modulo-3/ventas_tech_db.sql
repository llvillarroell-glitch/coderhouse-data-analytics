-- ══════════════════════════════════════════
-- Ventas_Tech_DB — TechStore
-- Autor: Lucas Villarroel Arancibia
-- Fecha: 01-09-2026
-- ══════════════════════════════════════════

-- Paso 0 - Creacion base de datos
CREATE DATABASE Ventas_Tech_DB;
GO
USE Ventas_Tech_DB;
GO

-- SECCION DDL --------------------------------------------

-- Paso 1: Eliminar tablas si ya existen, en orden inverso de dependencias
-- (ventas depende de clientes/productos; productos depende de categorias)
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

-- Paso 2: Crear tablas en orden de dependencias (dimensiones primero, hechos al final)

-- Tabla categorias: no depende de ninguna otra tabla
CREATE TABLE categorias (
	id_categoria		INT PRIMARY KEY,					-- INT: es un identificador simple, no requiere decimales ni texto.
	nombre_categoria	VARCHAR(50) NOT NULL,
	descripcion			VARCHAR(200)
	);

-- Tabla clientes: no depende de ninguna otra tabla
CREATE TABLE clientes (
	id_cliente		INT PRIMARY KEY,
	nombre			VARCHAR(100) NOT NULL,
	email			VARCHAR(100) UNIQUE,					-- UNIQUE, evita que dos clientes se registren con el mismo correo
	ciudad			VARCHAR(50),
	fecha_registro	DATE NOT NULL							-- DATE,  permite ordenar/filtrar por antigüedad de registro, un VARCHAR no lo permitiría
	);

--  Tabla productos: depende de categorias (FK)
CREATE TABLE productos (
    id_producto      INT PRIMARY KEY,
    nombre_producto  VARCHAR(100) NOT NULL,
    id_categoria     INT NOT NULL,
    precio           DECIMAL(10,2) NOT NULL CHECK (precio >= 0),   -- CHECK: evita cargar un precio negativo por error
    stock            INT DEFAULT 0 CHECK (stock >= 0),             -- CHECK: el stock nunca puede ser negativo
    activo           BIT DEFAULT 1,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Tabla ventas (tabla de hechos): depende de clientes y productos (FK)
CREATE TABLE ventas (
    id_venta         INT PRIMARY KEY,
    id_cliente       INT NOT NULL,
    id_producto      INT NOT NULL,
    cantidad         INT NOT NULL CHECK (cantidad > 0),            -- CHECK: no tiene sentido una venta de 0 o menos unidades
    precio_unitario  DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    fecha_venta      DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- SECCION DML -----------------------------------------------------

-- Paso 3: Carga inicial de datos 

-- categorias — 4 registros
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES
(1, 'Computación',    'Laptops, PCs y monitores'),
(2, 'Accesorios',     'Periféricos y complementos'),
(3, 'Audio',          'Auriculares y parlantes'),
(4, 'Almacenamiento', 'Discos y memorias');

-- clientes — 5 registros
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES
(1, 'María López',  'maria@mail.com',  'Buenos Aires', '2024-01-05'),
(2, 'Carlos Ruiz',  'carlos@mail.com', 'Córdoba',      '2024-01-10'),
(3, 'Ana Gómez',    'ana@mail.com',    'Rosario',      '2024-02-01'),
(4, 'Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15'),
(5, 'Laura Torres', 'laura@mail.com',  'Tucumán',      '2024-03-01');

-- productos — 6 registros
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES
(1, 'Laptop Pro 15',       1, 1200.00, 15, 1),
(2, 'Mouse Inalámbrico',   2,   28.00, 80, 1),
(3, 'Monitor 4K 27"',      1,  450.00, 12, 1),
(4, 'Auriculares BT Pro',  3,  120.00, 35, 1),
(5, 'SSD Externo 1TB',     4,  130.00, 18, 1),
(6, 'Teclado Mecánico',    2,   95.00, 40, 1);

-- ventas — 10 registros
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES
(1,  1, 1, 2, 1200.00, '2024-03-05'),
(2,  2, 2, 5,   28.00, '2024-03-06'),
(3,  3, 3, 1,  450.00, '2024-03-07'),
(4,  1, 4, 2,  120.00, '2024-03-08'),
(5,  4, 5, 3,  130.00, '2024-03-10'),
(6,  2, 6, 4,   95.00, '2024-03-11'),
(7,  5, 1, 1, 1200.00, '2024-03-12'),
(8,  3, 2, 8,   28.00, '2024-03-13'),
(9,  4, 4, 1,  120.00, '2024-03-14'),
(10, 5, 3, 2,  450.00, '2024-03-15');

-- Paso 4: Validación — confirmar que las 4 tablas se cargaron correctamente
SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;
