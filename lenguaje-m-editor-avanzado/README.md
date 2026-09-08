# lenguaje-m-editor-avanzado

Limpieza de una tabla de ventas de TechStore escrita directamente en código M, sin usar los botones de la interfaz de Power Query.

## Contenido

- `script_limpieza.md`: código M completo y funcional, con comentarios en cada paso.
- Este archivo (`README.md`): respuestas a las preguntas conceptuales.

## Resultado esperado

La tabla original tiene 7 filas. Tras aplicar el script, quedan **5 filas** (se eliminan los 2 registros con categoría "PRUEBA"), con `nombre_producto` en mayúsculas y sin espacios sobrantes, y `categoria` estandarizada en Title Case.

## Preguntas de reflexión

### ¿Qué hace exactamente el bloque let...in en lenguaje M? ¿Por qué cada paso puede referenciar al anterior?

El bloque `let` es donde se define cada paso de la transformación como una variable con nombre — en este script, `Origen`, `LimpiarEspacios`, `EstandarizarCategoria`, `EliminarPruebas` y `TiparColumnas`. El bloque `in`, al final, indica cuál de esas variables es el resultado que finalmente se muestra como la tabla de salida.

Cada paso puede referenciar al anterior porque M evalúa el bloque `let` de arriba hacia abajo, y cada variable queda disponible para las líneas que vienen después de ella. Por eso `LimpiarEspacios` puede usar `Origen` como su tabla de entrada, `EstandarizarCategoria` puede partir de `LimpiarEspacios`, y así sucesivamente — es una cadena donde cada eslabón se apoya en el resultado del anterior, nunca al revés. Esto es lo que permite leer el script como una receta: se puede seguir el rastro completo de una transformación mirando qué variable usa a cuál.

### ¿Por qué M es Case Sensitive y qué consecuencia práctica tiene? Dá un ejemplo de un error que esto puede causar.

M distingue mayúsculas de minúsculas tanto en los nombres de sus funciones nativas como en los nombres de las variables que define el propio usuario. En este script, si el Paso 2 se hubiera llamado `LimpiarEspacios` pero en el Paso 3 se lo referenciara como `limpiarEspacios` (con minúscula inicial), M no lo reconocería como la misma variable y devolvería un error de tipo "el identificador no existe en el ámbito actual" — aunque para una persona ambos nombres se vean casi idénticos. Lo mismo pasa con las funciones: `Table.TransformColumns` funciona, pero `table.transformcolumns` no, porque M busca el nombre exacto, letra por letra, incluida la capitalización.

### ¿Cuál es la diferencia entre usar Text.Trim y Text.Clean en M?

`Text.Trim` elimina únicamente los espacios en blanco que están al principio y al final de un texto — es lo que se usó en este script sobre `nombre_producto`, para sacar los espacios sobrantes de valores como `" Laptop Pro 15 "`. `Text.Clean`, en cambio, elimina caracteres no imprimibles (como saltos de línea, tabulaciones o caracteres de control invisibles) que a veces quedan pegados en un texto al exportarlo desde otro sistema, pero no toca los espacios normales entre palabras ni al principio o final del texto. Para este ejercicio, `Text.Trim` era la función correcta porque el problema era específicamente espacios sobrantes, no caracteres de control ocultos.

### ¿Por qué filtraste los registros "PRUEBA" después de estandarizar la categoría y no antes?

Porque antes de estandarizar, los valores de `categoria` podían tener cualquier combinación de mayúsculas y minúsculas ("PRUEBA", "prueba", "Prueba"). Si el filtro `[categoria] <> "Prueba"` se hubiera aplicado *antes* del Paso 3, solo habría eliminado las filas que coincidieran exactamente con el texto `"Prueba"` (con esa capitalización exacta) — cualquier variante como `"PRUEBA"` en mayúsculas hubiera pasado el filtro sin ser detectada, porque M es Case Sensitive. Al estandarizar primero con `Text.Proper` (que convierte todo a Title Case) y filtrar después, el script queda protegido contra cualquier forma en que el dato de prueba haya sido cargado originalmente — mismo principio de robustez que la pregunta anterior sobre Case Sensitivity.
