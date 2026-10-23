-- 04. Análisis exploratorio: tres consultas de agregación
USE evaluacion_final;
GO

-- 4a. Facturación por mes
SELECT FORMAT(v.FechaCompra, 'yyyy-MM') AS mes, COUNT(*) AS transacciones,
       SUM(COALESCE(v.MontoTotal, v.Cantidad * p.PrecioUnitario)) AS facturacion
FROM Ventas v INNER JOIN Productos p ON v.ProductID = p.ProductID
GROUP BY FORMAT(v.FechaCompra, 'yyyy-MM') ORDER BY mes;

-- 4b. Facturación por categoría
SELECT p.Categoria, COUNT(*) AS transacciones,
       SUM(COALESCE(v.MontoTotal, v.Cantidad * p.PrecioUnitario)) AS facturacion
FROM Ventas v INNER JOIN Productos p ON v.ProductID = p.ProductID
GROUP BY p.Categoria ORDER BY facturacion DESC;

-- 4c. Facturación por segmento de cliente
SELECT c.Segmento,
       COUNT(DISTINCT v.CustomerID) AS clientes,
       COUNT(*) AS transacciones,
       SUM(COALESCE(v.MontoTotal, v.Cantidad * p.PrecioUnitario)) AS facturacion
FROM Ventas v INNER JOIN Clientes c ON v.CustomerID = c.CustomerID
              INNER JOIN Productos p ON v.ProductID = p.ProductID
GROUP BY c.Segmento ORDER BY facturacion DESC;
GO
