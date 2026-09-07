-- ══════════════════════════════════════════
-- RetailChain — UNION y UNION ALL
-- Autor: Lucas Villarroel Arancibia
-- Fecha: 07-09-2026
-- ══════════════════════════════════════════

-- ── CONSULTA 1: UNION ────────────────────
-- Reporte de Catálogo Unificado
-- Pregunta de negocio: ¿Qué productos únicos comercializa
-- la empresa en toda su red de sucursales?
-- Operador: UNION (elimina filas completamente duplicadas)
-- Nota de diseño: acá NO se incluye la columna stock, porque el "catálogo"
-- es una pregunta sobre identidad del producto (qué se vende), no sobre
-- cuánto stock hay en cada sucursal. Al no incluir stock, los productos
-- 103, 104 y 106 (idénticos en id, nombre y categoría en ambas sucursales)
-- se cuentan una sola vez.
SELECT id_producto, nombre_producto, categoria
FROM inventario_sucursal_norte
UNION
SELECT id_producto, nombre_producto, categoria
FROM inventario_sucursal_sur;

-- ── CONSULTA 2: UNION ALL ────────────────
-- Auditoría de Stock Total
-- Pregunta de negocio: ¿Cuántos registros físicos de stock
-- existen en total entre ambas sucursales?
-- Operador: UNION ALL (mantiene todos los registros incluyendo duplicados)
-- Nota de diseño: acá SÍ se incluye stock, porque operaciones necesita
-- ver el stock físico de cada sucursal por separado, sin que se pierda
-- ningún registro aunque el producto se repita entre sucursales.
SELECT id_producto, nombre_producto, categoria, stock
FROM inventario_sucursal_norte
UNION ALL
SELECT id_producto, nombre_producto, categoria, stock
FROM inventario_sucursal_sur;

-- ── CONSULTA 3: COMPARACIÓN DE RESULTADOS ─
-- Ejecutá estas dos consultas para comparar cuántas filas
-- devuelve cada operador y explicá la diferencia en el README.

SELECT COUNT(*) AS filas_union
FROM (
    SELECT id_producto, nombre_producto, categoria
    FROM inventario_sucursal_norte
    UNION
    SELECT id_producto, nombre_producto, categoria
    FROM inventario_sucursal_sur
) AS resultado_union;

SELECT COUNT(*) AS filas_union_all
FROM (
    SELECT id_producto, nombre_producto, categoria, stock
    FROM inventario_sucursal_norte
    UNION ALL
    SELECT id_producto, nombre_producto, categoria, stock
    FROM inventario_sucursal_sur
) AS resultado_union_all;
