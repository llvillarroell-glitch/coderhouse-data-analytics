-- ──────────────────────────────────────────
-- BodegaTech — Script de Inventario
-- Autor: Lucas Villarroel Arancibia
-- ──────────────────────────────────────────

-- SECCION DML --

-- Eliminar la tabla si ya existe, para poder re-ejecutar el script sin errores -- 
DROP TABLE IF EXISTS inventario;

-- Creacion de tabla con estructura definida -- 
CREATE TABLE inventario (
    id_producto     INT PRIMARY KEY,                  
    nombre_producto VARCHAR(100) NOT NULL,            
    categoria       VARCHAR(50) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,            
    stock_actual    INT NOT NULL,
    stock_minimo    INT NOT NULL,
    fecha_ingreso   DATE NOT NULL,                     
    activo          BIT NOT NULL DEFAULT 1     
    );

-- Seccion DML --

-- Carga inicial de los productos -- 

    INSERT INTO inventario (id_producto, nombre_producto, categoria, precio_unitario, stock_actual, stock_minimo, fecha_ingreso, activo) VALUES
(1,  'Laptop Pro 15',        'Computación',    1200.00, 15, 3,  '2024-01-10', 1),
(2,  'Mouse Inalámbrico',    'Accesorios',       28.00, 80, 10, '2024-01-10', 1),
(3,  'Monitor 4K 27"',       'Computación',     450.00, 12, 2,  '2024-01-15', 1),
(4,  'Teclado Mecánico',     'Accesorios',       95.00, 40, 5,  '2024-01-15', 1),
(5,  'Laptop Basic 14',      'Computación',     650.00, 20, 3,  '2024-02-01', 1),
(6,  'Auriculares BT Pro',   'Audio',           120.00, 35, 5,  '2024-02-01', 1),
(7,  'Hub USB-C 7 puertos',  'Accesorios',       45.00, 60, 10, '2024-02-10', 1),
(8,  'Webcam HD 1080p',      'Accesorios',       85.00, 25, 5,  '2024-02-10', 1),
(9,  'SSD Externo 1TB',      'Almacenamiento',  130.00, 18, 3,  '2024-03-01', 1),
(10, 'Parlante Bluetooth',   'Audio',            60.00, 45, 8,  '2024-03-01', 1);

--Registro de ventas del dia, actualizado stock_actual -- 

-- Laptop Pro 15(id,1): Se vendieron 3 unidades -> 15-3 = 12
UPDATE inventario
SET stock_actual = stock_actual - 3
WHERE id_producto = 1;

-- Mouse Inalámbrico (id,2): Se vendieron 12 unidades -> 80 - 12 = 68
UPDATE inventario
SET stock_actual = stock_actual - 12
WHERE id_producto = 2;

-- Auriculares BT Pro (id,6):  Se vendieron 5 unidades -> 35 -5 = 30
UPDATE inventario
SET stock_actual = stock_actual -5
WHERE id_producto = 6;

-- Marcar Webcam HD 1080p (id,8) como descontinuada -- 
UPDATE inventario
SET activo = 0
WHERE id_producto = 8;

-- Validacion, confirmacion de la carga y actualizaciones --
SELECT * FROM inventario;
