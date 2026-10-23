-- 02. Revisión de calidad de los datos (ejecutar después de cargar los CSV)
USE evaluacion_final;
GO

SELECT
    SUM(CASE WHEN MontoTotal IS NULL THEN 1 ELSE 0 END) AS montototal_vacio,
    SUM(CASE WHEN Cantidad   IS NULL THEN 1 ELSE 0 END) AS cantidad_vacia,
    COUNT(*)                                            AS total_filas,
    COUNT(*) - COUNT(DISTINCT TransactionID)            AS ids_transaccion_repetidos,
    MIN(FechaCompra)                                    AS primera_venta,
    MAX(FechaCompra)                                    AS ultima_venta
FROM Ventas;
-- Resultado esperado: 10 | 20 | 3000 | 5 | 2024-04-05 | 2025-04-07
GO
