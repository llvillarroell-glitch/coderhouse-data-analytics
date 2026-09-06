-- -------------------------------------------
-- RetailPro — Consultas SQL de Negocio (M4)
-- Autor: Lucas Villarroel Arancibia
-- Fecha: 06-09-2026
-- Base de datos: Ventas_Tech_DB (tabla ventas, creada en M3)
-- -------------------------------------------

-- Consulta 1: Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, agrupado por mes.
-- Nota de motor: se usa MONTH() en vez de EXTRACT(MONTH FROM ...) porque este script corre sobre SQL Server, donde EXTRACT no es sintaxis válida.
SELECT
    MONTH(fecha_venta)                       AS mes,
    SUM(cantidad * precio_unitario)          AS total_facturado,
    COUNT(*)                                  AS cantidad_pedidos,
    AVG(cantidad * precio_unitario)           AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

-- Consulta 2: Ranking de productos (Top 5 por total facturado)
-- Nota de motor: se usa TOP 5 (SQL Server) en vez de LIMIT 5 (PostgreSQL/MySQL).
SELECT TOP 5
    id_producto,
    SUM(cantidad)                             AS unidades_vendidas,
    SUM(cantidad * precio_unitario)           AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- Consulta 3: Clientes recurrentes
-- Clientes con más de un pedido, con cantidad de pedidos y total gastado.
SELECT
    id_cliente,
    COUNT(*)                                  AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)           AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- Consulta 4: Meses por encima/por debajo del promedio
-- Total facturado por mes, etiquetado según si superó o no el promedio mensual general (calculado sobre todos los meses disponibles).
WITH ventas_mensuales AS (
    SELECT
        MONTH(fecha_venta)                    AS mes,
        SUM(cantidad * precio_unitario)       AS total_mes
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_mes,
    CASE
        WHEN total_mes > (SELECT AVG(total_mes) FROM ventas_mensuales) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS clasificacion
FROM ventas_mensuales;

-- -------------------------------------------
-- Hallazgos
-- -------------------------------------------
-- 1. Los 5 clientes registrados en la base (id_cliente 1 a 5) son recurrentes:
-- cada uno realizó exactamente 2 pedidos. Esto implica una tasa de recurrencia del 100% sobre la base actual, aunque con una muestra todavía chica (10 pedidos en total) para sacar conclusiones definitivas.
--
-- 2. El producto con id_producto = 1 (Laptop Pro 15) concentra aproximadamente el 55.9% de la facturación total ($3,600 de $6,444), muy por encima de cualquier otro producto del catálogo, es el principal impulsor de ingresos.
--
-- 3. Limitación de los datos actuales: los 10 registros de venta caen todos dentro de un único mes (marzo de 2024), por lo que la Consulta 4 (comparación contra el promedio mensual) no aporta información
--    accionable todavía — solo hay un mes para comparar contra sí mismo.
--    Esta consulta va a volverse útil en cuanto la base incorpore ventas de más de un mes.
