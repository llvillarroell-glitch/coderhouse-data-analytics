-- 03. Ejercicio 1: ventas de los últimos 30 días contados desde la última venta del dataset
-- La fecha de corte no se escribe a mano: se obtiene con MAX(FechaCompra).
USE evaluacion_final;
GO

SELECT
    c.Nombre      AS nombre_cliente,
    v.FechaCompra AS fecha_compra,
    COALESCE(v.MontoTotal, v.Cantidad * p.PrecioUnitario) AS total_venta
FROM Ventas v
INNER JOIN Clientes  c ON v.CustomerID = c.CustomerID
INNER JOIN Productos p ON v.ProductID  = p.ProductID
WHERE v.FechaCompra >= (SELECT DATEADD(DAY, -30, MAX(FechaCompra)) FROM Ventas)
ORDER BY v.FechaCompra DESC;
-- Resultado esperado: 257 filas (ventana 08/03/2025 - 07/04/2025), suma de total_venta = 116728.78
GO
