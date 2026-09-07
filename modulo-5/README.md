# RetailChain — UNION y UNION ALL

Consolidación del inventario de las sucursales Norte y Sur de RetailChain, comparando el resultado de `UNION` (catálogo único de productos) contra `UNION ALL` (auditoría completa de stock físico).

## Contenido

- `schema.sql`: creación de `inventario_sucursal_norte` e `inventario_sucursal_sur`, con productos exclusivos de cada sucursal y productos compartidos con distinto stock.
- `soluciones.sql`: las 3 consultas requeridas.

## Preguntas de reflexión

### ¿Cuántas filas devuelve cada consulta y por qué son distintas?
La Consulta 1 (`UNION`) devuelve **11 filas**, y la Consulta 2 (`UNION ALL`) devuelve **14 filas** — la suma exacta de los 7 registros de la Sucursal Norte más los 7 de la Sucursal Sur.

La diferencia de 3 filas se explica porque, en la Consulta 1, no incluí la columna `stock` a propósito. Sin esa columna, los productos 103 (Monitor 4K 27"), 104 (Teclado Mecánico) y 106 (SSD Externo 1TB) quedan con 
exactamente el mismo `id_producto`, `nombre_producto` y `categoria` en ambas sucursales, así que `UNION` los reconoce como filas idénticas y los reduce a una sola fila cada uno — 3 duplicados eliminados, 14 - 3 = 11.

Importante: la Webcam HD 1080p **no** se deduplicó, aunque tiene el mismo nombre en ambas sucursales, porque tiene `id_producto` distinto (107 en Norte, 111 en Sur) — para `UNION`, esas dos filas no son idénticas, 
son productos distintos con nombres coincidentes.

### ¿Por qué UNION ALL es más eficiente que UNION? ¿Qué operación adicional realiza UNION internamente?
`UNION ALL` simplemente concatena los resultados de ambas consultas, una debajo de la otra, sin comparar nada. `UNION`, en cambio, tiene que comparar cada fila contra todas las demás para detectar cuáles son idénticas y 
eliminarlas — internamente esto generalmente implica una operación de ordenamiento o un proceso de hash sobre el resultado completo antes de poder identificar los duplicados. Con 14 filas esa diferencia es insignificante, 
pero en una tabla real con millones de registros, ese paso extra de comparación puede ser costoso en tiempo y en uso de memoria.

### ¿En qué casos de negocio usarías cada uno? Dá al menos dos ejemplos distintos a los del ejercicio.
**UNION** (necesito unicidad): al construir una lista de correos para una campaña de marketing combinando las bases de datos de dos sistemas CRM distintos que se fusionaron — no quiero mandarle el mismo mail dos veces 
a una persona que está registrada en ambos sistemas. Otro caso: al armar un directorio único de empleados después de una fusión de dos empresas, donde algunas personas ya trabajaban en ambas compañías antes de la fusión.

**UNION ALL** (necesito el total real): al consolidar los logs de transacciones de dos pasarelas de pago distintas para un reporte de volumen total — cada transacción es un evento real e independiente, 
aunque dos transacciones tengan montos y fechas parecidas, no son duplicados que haya que eliminar. Otro caso: al juntar los registros de acceso (logs) de varios servidores para una auditoría de seguridad, 
donde cada entrada representa un evento distinto que ocurrió en un momento específico, y perder alguno por deduplicación accidental escondería actividad real.

### ¿Qué pasa si las columnas de ambas consultas no coinciden en número o tipo? ¿Qué error genera SQL?
Si el número de columnas no coincide, SQL Server devuelve un error indicando que todas las consultas combinadas con `UNION` deben tener la misma cantidad de expresiones en su lista de columnas
(algo como *"All queries combined using a UNION, INTERSECT or EXCEPT operator must have an equal number of expressions in their target lists"*). Si el número de columnas coincide pero los tipos de datos no son 
compatibles entre sí (por ejemplo, intentar combinar una columna de texto con una numérica sin conversión posible), SQL Server tira un error de conversión de tipos al no poder alinear ambos resultados en un tipo de dato
común.

En mi caso, ambas partes de cada `UNION` seleccionan exactamente las mismas columnas, en el mismo orden y con los mismos tipos (porque `inventario_sucursal_norte` e `inventario_sucursal_sur` 
comparten idéntica estructura), así que ninguno de estos errores ocurre.
