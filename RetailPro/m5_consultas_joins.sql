-- ══════════════════════════════════════════
-- RetailPro — Consultas con JOINs (M5)
-- Autor: Lucas Villarroel Arancibia
-- Fecha: 07-09-2026
-- Base de datos: Ventas_Tech_DB (extendida con territorios/segmento/canal)
-- ══════════════════════════════════════════

-- ── CONSULTA 1: Vista base del proyecto (INNER JOIN) ──
-- Combina ventas + clientes + productos + territorios en una sola fila.
-- Esta consulta es la fuente de datos principal que va a alimentar Power BI en M7.
SELECT
    v.fecha_venta,
    c.nombre               AS nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    p.id_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta,
    v.canal
FROM ventas v
INNER JOIN clientes c   ON v.id_cliente = c.id_cliente
INNER JOIN productos p  ON v.id_producto = p.id_producto
INNER JOIN territorios t ON c.id_territorio = t.id_territorio;

-- ── CONSULTA 2: Clientes sin ventas (LEFT JOIN) ──
-- Pregunta de CRM: ¿qué clientes registrados todavía no compraron nada?
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- ── CONSULTA 3: Productos sin ventas (LEFT JOIN) ──
-- Pregunta de producto: ¿qué artículos del catálogo no tienen movimiento?
SELECT
    p.nombre_producto,
    p.id_categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- ── CONSULTA 4: Consolidado por canal (UNION ALL) ──
-- Combina ventas Online y Presencial en un solo resultado, con el total por canal.
SELECT
    canal,
    SUM(total_venta) AS total_por_canal
FROM (
    SELECT canal, (cantidad * precio_unitario) AS total_venta
    FROM ventas
    WHERE canal = 'Online'

    UNION ALL

    SELECT canal, (cantidad * precio_unitario) AS total_venta
    FROM ventas
    WHERE canal = 'Presencial'
) AS ventas_consolidadas
GROUP BY canal;

-- ══════════════════════════════════════════
-- Hallazgos
-- ══════════════════════════════════════════
-- 1. El cliente Diego Fernández (id_cliente = 6) es el único registrado
--    sin ninguna compra todavía — candidato directo para una campaña
--    de activación de CRM.
--
-- 2. El Router WiFi 6 (id_producto = 7) es el único producto del catálogo
--    sin ventas registradas — vale la pena revisar si es un producto
--    recién agregado o si necesita impulso comercial.
--
-- 3. Aunque el canal Online y el canal Presencial tuvieron la misma
--    cantidad de transacciones (5 cada uno), Online generó $4,560 frente
--    a $1,884 de Presencial — más del doble de facturación con el mismo
--    volumen de operaciones. Esto sugiere que las compras Online tienden
--    a ser de mayor valor promedio, y sería un punto a profundizar en
--    Power BI (M7) comparando el ticket promedio por canal.
