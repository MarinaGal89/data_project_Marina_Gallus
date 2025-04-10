/*
2. Muestra los nombres de todas las películas con una clasificación por
edades de ‘R'.
*/

SELECT "title"
FROM "film"
WHERE "rating" = 'R';


/*
3. Encuentra los nombres de los actores que tengan un “actor_id entre 30
y 40.
*/

SELECT CONCAT("first_name", ' ', "last_name") AS "nombreapellido_actor", "actor_id"
FROM "actor"
WHERE "actor_id" BETWEEN 30 AND 40;


/*
4. Obtén las películas cuyo idioma coincide con el idioma original.
*/

SELECT "film_id", "title"
FROM "film"
WHERE "language_id" = "original_language_id";


/*
5. Ordena las películas por duración de forma ascendente.
*/

SELECT "film_id", "title","length"
FROM "film"
ORDER BY "length" ASC;


/*
 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen en su
apellido.
 */

SELECT "first_name", "last_name"
FROM "actor"
WHERE "last_name" LIKE '%ALLEN%';


/*
 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.
 */

SELECT "rating", COUNT("rating") AS "numero_peliculas"
FROM "film"
GROUP BY "rating";


/*
 8. Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una duración mayor a 3 horas en la tabla film.
 */

SELECT "title", "rating", "length"
FROM "film"
WHERE "rating" = 'PG-13' or "length" > 180;


/*
 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
 */

SELECT ROUND (variance ("replacement_cost"), 2) AS "varianza_remplazo"
FROM "film";


/*
 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
 */

SELECT MIN("length") AS "menor_duración", MAX("length") AS "mayor_duración"
FROM "film";


/*
 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
 */

SELECT "amount", "payment_date"
FROM "payment"
ORDER BY "payment_date" DESC
OFFSET 2 LIMIT 1;


/*
 12. Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC 17ʼ ni ‘Gʼ en cuanto a su clasificación.
 */

SELECT "title", "rating"
FROM "film"
WHERE "rating" NOT IN ('NC-17', 'G');


/*
13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
*/

SELECT "rating", ROUND (AVG ("length")) AS "duración_promedio"
FROM "film"
GROUP BY "rating";


/*
 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
 */

SELECT "title", "length"
FROM "film"
WHERE "length" > 180; 


/*
 15. ¿Cuánto dinero ha generado en total la empresa?
 */

SELECT ROUND( SUM ("amount"), 2) AS "facturación_empresa"
FROM "payment";


/*
 16. Muestra los 10 clientes con mayor valor de id.
 */

SELECT  "customer_id", CONCAT ("first_name", ' ', "last_name") AS "nombre_cliente"
FROM "customer"
ORDER BY "customer_id" DESC
LIMIT 10;


/*
 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
 */

SELECT CONCAT("first_name", ' ', "last_name") AS "actor_name"
FROM "actor"
WHERE "actor_id" IN (
    SELECT "actor_id"
    FROM "film_actor"
    WHERE "film_id" IN (
        SELECT "film_id"
        FROM "film"
        WHERE "title" = 'EGG IGBY'
    )
);


/*
 18. Selecciona todos los nombres de las películas únicos.
 */


SELECT DISTINCT "title"
FROM "film";


/*
 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.
 */

CREATE VIEW "tabla_titulopelicula_categoria" AS 
SELECT 
    f."film_id",
    f."title" AS "titulo_pelicula",
    c."name",
    f."length"

FROM "film" f
    INNER JOIN "film_category" fc
    ON f."film_id" = fc."film_id"
    INNER JOIN "category" c
    ON fc."category_id" = c."category_id";


/*
 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
 */

CREATE VIEW "tabla_titulopelicula_categoria" AS 
SELECT 
    f."film_id",
    f."title" AS "titulo_pelicula",
    c."name",
    f."length"
FROM "film" f
    INNER JOIN "film_category" fc
    ON f."film_id" = fc."film_id"
    INNER JOIN "category" c
    ON fc."category_id" = c."category_id";

SELECT 
    "name" AS "category_name",
    ROUND(AVG("length"), 0) AS "duración_promedio"
FROM "tabla_titulopelicula_categoria"
GROUP BY "name"
HAVING AVG("length") > 110;


/*
21. ¿Cuál es la media de duración del alquiler de las películas?
*/

SELECT ROUND(AVG("rental_duration"), 2) AS "promedio_dias_alquiler"
FROM "film";


/*
22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
*/

SELECT CONCAT("first_name", ' ', "last_name") AS "nombre_actor"
FROM "actor"; 


/*
23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
*/

SELECT 
   CAST("rental_date" AS DATE) AS "día_alquiler",
   COUNT("rental_id") AS "alquileres_por_día"
FROM "rental"
GROUP BY "día_alquiler"
ORDER BY "alquileres_por_día" DESC;


/*
24. Encuentra las películas con una duración superior al promedio.
*/

SELECT "film_id", "title", "length"
FROM "film"
WHERE "length" > (
    SELECT AVG("length")
    FROM "film"
); 


/*
25. Averigua el número de alquileres registrados por mes.
*/

SELECT 
    TO_CHAR("rental_date", 'YYYY-MM') AS "mes",
    COUNT(*) AS "alquileres_mes"
FROM "rental"
GROUP BY TO_CHAR("rental_date", 'YYYY-MM')
ORDER BY "mes" ASC; 


/*
26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
*/

SELECT 
    ROUND(AVG("amount"), 2) AS "promedio_pagado",
    ROUND(STDDEV("amount"), 2) AS "desviacion_std_pagado",
    ROUND(VARIANCE("amount"), 2) AS "varianza_pagado"
FROM "payment";


/*
27. ¿Qué películas se alquilan por encima del precio medio?
*/

CREATE VIEW "precio_por_pelicula" AS
SELECT 
    f."film_id",
    f."title",
    p."amount",
    r."rental_id",
    i."inventory_id"
FROM "film" f 
    INNER JOIN "inventory" i 
        ON f."film_id" = i."film_id"
    INNER JOIN "rental" r 
        ON i."inventory_id" = r."inventory_id"
    INNER JOIN "payment" p 
        ON p."rental_id" = r."rental_id";

WITH "promedio_precio" AS (
    SELECT 
        AVG("amount") AS "promedio"
    FROM "precio_por_pelicula"
)
SELECT 
    "film_id",
    "title",
    ROUND(AVG("amount"), 2) AS "precio_medio"
FROM "precio_por_pelicula"
GROUP BY "film_id", "title"
HAVING ROUND(AVG("amount"), 2) > (SELECT "promedio" FROM "promedio_precio");


/*
28. Muestra el id de los actores que hayan participado en más de 40 películas.
*/

SELECT "actor_id", COUNT("film_id") AS "total_peliculas"
FROM "film_actor"
GROUP BY "actor_id"
HAVING COUNT("film_id") > 40
ORDER BY "total_peliculas" DESC;


/*
29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
*/

SELECT 
    f."film_id",
    f."title",
    COUNT(i."inventory_id") AS "copias_disponibles"
FROM "film" f
LEFT JOIN "inventory" i 
    ON f."film_id" = i."film_id"
GROUP BY f."film_id", f."title"
ORDER BY f."title";


/*
30. Obtener los actores y el número de películas en las que ha actuado.
*/

SELECT 
    a."actor_id",
    CONCAT("first_name", ' ', "last_name") AS "nombre_apellido",
    COUNT(fa."film_id") AS "total_peliculas"
FROM "actor" AS a
LEFT JOIN "film_actor" AS fa
    ON a."actor_id" = fa."actor_id" 
GROUP BY a."actor_id", a."first_name", a."last_name";


/*
31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
*/

SELECT 
    f."film_id",
    f."title",
    CONCAT(a."first_name", ' ', a."last_name") AS "actor_name"
FROM "film" f
    LEFT JOIN "film_actor" fa
        ON f."film_id" = fa."film_id"
    LEFT JOIN "actor" a 
        ON fa."actor_id" = a."actor_id"
ORDER BY f."film_id", "actor_name" ASC;


/* 
32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
*/

SELECT 
    a."actor_id",
    CONCAT(a."first_name", ' ', a."last_name") AS "Nombre_Apellido_Actor",
    f."film_id",
    f."title" AS "film_title"
FROM "actor" a
    LEFT JOIN "film_actor" fa
        ON a."actor_id" = fa."actor_id"
    LEFT JOIN "film" f 
        ON fa."film_id" = f."film_id"
ORDER BY a."actor_id", f."title" ASC;


/*
33. Obtener todas las películas que tenemos y todos los registros de alquiler.
*/

SELECT 
    f."film_id",
    f."title" AS "film_title",
    r."rental_id"
FROM "film" f
    LEFT JOIN "inventory" i
        ON f."film_id" = i."film_id"
    LEFT JOIN "rental" r
        ON i."inventory_id" = r."inventory_id"
ORDER BY f."film_id", r."rental_id";


/*
34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
*/

SELECT 
    c."customer_id",
    CONCAT(c."first_name", ' ', c."last_name") AS "customer_name",
    ROUND(SUM(p."amount"), 2) AS "total_pagado"
FROM "customer" c
LEFT JOIN "payment" p 
    ON c."customer_id" = p."customer_id"
GROUP BY c."customer_id", c."first_name", c."last_name"
ORDER BY "total_pagado" DESC
LIMIT 5;


/*
35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
*/

SELECT "actor_id", "first_name", "last_name"
FROM "actor"
WHERE "first_name" = 'JOHNNY';


/*
36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
*/

SELECT 
    "actor_id",
    "first_name" AS "Nombre", 
    "last_name" AS "Apellido"
FROM "actor"
WHERE "first_name" = 'JOHNNY';


/*
37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
*/

SELECT 
    MIN("actor_id") AS "Id_mas_bajo",
    MAX("actor_id") AS "Id_mas_alto"
FROM "actor";


/*
38. Cuenta cuántos actores hay en la tabla “actor”.
*/

SELECT 
    COUNT("actor_id") AS "total_actores"
FROM "actor";


/*
39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
*/

SELECT 
    "actor_id",
    "first_name",
    "last_name"
FROM "actor"
ORDER BY "last_name" ASC;


/*
40. Selecciona las primeras 5 películas de la tabla “film”.
*/

SELECT 
    "film_id",
    "title"
FROM "film"
LIMIT 5;


/*
41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
*/

SELECT
    "first_name",
    COUNT("first_name") AS "actores_por_nombre"
FROM "actor"
GROUP BY "first_name"
ORDER BY "actores_por_nombre" DESC;

-- los nombres màs repetidos son 'Kenneth', 'Penelope' y 'Julia' -- 

/*
42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
*/

SELECT 
    r."rental_id",
    CONCAT(c."first_name", ' ', c."last_name") AS "nombre_cliente"
FROM "rental" r
LEFT JOIN "customer" c
    ON r."customer_id" = c."customer_id";


/*
43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
*/

SELECT 
    CONCAT(c."first_name", ' ', c."last_name") AS "nombre_cliente",
    r."rental_id"
FROM "customer" c
LEFT JOIN "rental" r
    ON c."customer_id" = r."customer_id"
ORDER BY "nombre_cliente";


/*
44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
*/

SELECT *
FROM "film" f
CROSS JOIN "category" c;

/*
Esta consulta no aporta ningún valor. 
A través de ella estamos realizando el producto cartesiano de las tablas Film y Category.
El resultado es, por ejemplo, que al film con id '1' se le asigna cada una de las categorías existentes en la tabla Category: si un film es comedia, no puede ser horror.
*/


/*
45. Encuentra los actores que han participado en películas de la categoría 'Action'.
*/

SELECT DISTINCT 
    a."actor_id",
    CONCAT(a."first_name", ' ', a."last_name") AS "nombre_actor"
FROM "actor" a
    JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
    JOIN "film" f ON fa."film_id" = f."film_id"
    JOIN "film_category" fc ON f."film_id" = fc."film_id"
    JOIN "category" c ON fc."category_id" = c."category_id"
WHERE c."name" = 'Action'
ORDER BY "nombre_actor";


/*
46. Encuentra todos los actores que no han participado en películas.
*/

SELECT
    a."actor_id",
    CONCAT(a."first_name", ' ', a."last_name") AS "nombre_actor",
    fa."film_id"
FROM "actor" a
LEFT JOIN "film_actor" fa
    ON a."actor_id" = fa."actor_id"
WHERE fa."film_id" IS NULL;


/*
47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
*/

SELECT
    a."actor_id",
    CONCAT(a."first_name", ' ', a."last_name") AS "nombre_actor",
    COUNT(fa."film_id") AS "peliculas_por_actor"
FROM "actor" a
LEFT JOIN "film_actor" fa
    ON a."actor_id" = fa."actor_id"
GROUP BY a."actor_id", a."first_name", a."last_name"
ORDER BY "peliculas_por_actor" DESC;


/*
48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
*/

CREATE VIEW "actor_num_peliculas" AS 
SELECT
    a."actor_id",
    CONCAT(a."first_name", ' ', a."last_name") AS "nombre_actor",
    COUNT(fa."film_id") AS "peliculas_por_actor"
FROM "actor" a
LEFT JOIN "film_actor" fa
    ON a."actor_id" = fa."actor_id"
GROUP BY a."actor_id", a."first_name", a."last_name"
ORDER BY "peliculas_por_actor" DESC;


/*
49. Calcula el número total de alquileres realizados por cada cliente.
*/

SELECT
    c."customer_id",
    CONCAT(c."first_name", ' ', c."last_name") AS "customer_name",
    COUNT(r."rental_id") AS "total_alquileres"
FROM "customer" c 
LEFT JOIN "rental" r 
    ON c."customer_id" = r."customer_id"
GROUP BY c."customer_id", c."first_name", c."last_name"
ORDER BY "total_alquileres" DESC;


/*
50. Calcula la duración total de las películas en la categoría 'Action'.
*/

CREATE VIEW "film_categoria" AS
SELECT 
    f."film_id",
    f."title",
    fc."category_id",
    c."name"
FROM "film" f
    INNER JOIN "film_category" fc
        ON f."film_id" = fc."film_id"
    INNER JOIN "category" c
        ON fc."category_id" = c."category_id";

SELECT 
    fca."name" AS "categoria",
    ROUND(SUM(f."length"), 2) AS "duracion_total"
FROM "film" f 
    INNER JOIN "film_categoria" fca
        ON f."film_id" = fca."film_id"
WHERE fca."name" = 'Action'
GROUP BY fca."name";


/*
51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
*/

CREATE TEMPORARY TABLE "cliente_rentas_temporal" AS
SELECT 
    c."customer_id",
    CONCAT(c."first_name", ' ', c."last_name") AS "nombre_cliente",
    COUNT(r."rental_id") AS "total_alquileres"
FROM "customer" c
LEFT JOIN "rental" r 
    ON c."customer_id" = r."customer_id"
GROUP BY c."customer_id", c."first_name", c."last_name"
ORDER BY "total_alquileres" DESC;


/*
52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
*/

CREATE TEMPORARY TABLE "peliculas_alquiladas" AS
SELECT 
    f."film_id",
    f."title",
    COUNT(r."rental_id") AS total_alquileres
FROM "film" f 
    JOIN "inventory" i 
        ON f."film_id" = i."film_id"
    JOIN "rental" r 
        ON i."inventory_id" = r."inventory_id"
GROUP BY f."film_id", f."title"
HAVING COUNT(r."rental_id") >= 10;


/*
53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
*/

SELECT 
    CONCAT(c."first_name", ' ', c."last_name") AS "nombre_cliente",
    f."title",
    r."return_date"
FROM "customer" c 
    INNER JOIN "rental" r 
        ON c."customer_id" = r."customer_id"
    INNER JOIN "inventory" i 
        ON r."inventory_id" = i."inventory_id"
    INNER JOIN "film" f 
        ON i."film_id" = f."film_id"
WHERE c."first_name" = 'TAMMY'
    AND c."last_name" = 'SANDERS'
    AND r."return_date" IS NULL
ORDER BY f."title" ASC;


/*
54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
*/

SELECT DISTINCT 
    a."actor_id",
    a."last_name",
    a."first_name"
FROM "category" c 
    INNER JOIN "film_category" fc 
        ON c."category_id" = fc."category_id"
    INNER JOIN "film" f 
        ON fc."film_id" = f."film_id"
    INNER JOIN "film_actor" fa 
        ON f."film_id" = fa."film_id"
    INNER JOIN "actor" a 
        ON fa."actor_id" = a."actor_id"
WHERE c."name" = 'Sci-Fi'
ORDER BY a."last_name";


/*
55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
*/

SELECT DISTINCT
    CONCAT(a."first_name", ' ', a."last_name") AS "nombre_actor"
FROM "actor" a
    JOIN "film_actor" fa ON a."actor_id" = fa."actor_id"
    JOIN "film" f ON fa."film_id" = f."film_id"
    JOIN "inventory" i ON f."film_id" = i."film_id"
    JOIN "rental" r ON i."inventory_id" = r."inventory_id"
WHERE r."rental_date" > (
    SELECT MIN(r2."rental_date")
    FROM "rental" r2
    JOIN "inventory" i2 ON r2."inventory_id" = i2."inventory_id"
    JOIN "film" f2 ON i2."film_id" = f2."film_id"
    WHERE f2."title" = 'SPARTACUS CHEAPER'
)
ORDER BY "nombre_actor";


/*
56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
*/

SELECT 
    a."first_name",
    a."last_name"
FROM "actor" a 
WHERE NOT EXISTS (
    SELECT 1
    FROM "film_actor" fa 
    JOIN "film" f ON fa."film_id" = f."film_id"
    JOIN "film_category" fc ON f."film_id" = fc."film_id"
    JOIN "category" c ON fc."category_id" = c."category_id"
    WHERE fa."actor_id" = a."actor_id" 
    AND c."name" = 'Music'
);


/*
57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
*/

SELECT f."title"
FROM "film" f
    JOIN "inventory" i ON f."film_id" = i."film_id"
    JOIN "rental" r ON i."inventory_id" = r."inventory_id"
WHERE DATE_PART('day', r."return_date" - r."rental_date") > 8;


/*
58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
*/

SELECT f."title"
FROM "film" f 
    JOIN "film_category" fc ON f."film_id" = fc."film_id" 
    JOIN "category" c ON fc."category_id" = c."category_id" 
WHERE c."category_id" = (
    SELECT "category_id" 
    FROM "category" c 
    WHERE "name" = 'Animation'
);


/*
59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
*/

SELECT "title"
FROM "film" f 
WHERE "length" = (
    SELECT "length"
    FROM "film" f 
    WHERE "title" = 'DANCING FEVER'
)
ORDER BY "title" ASC;


/*
60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
*/

SELECT 
    CONCAT(c."first_name", ' ', c."last_name") AS "nombre_cliente",
    COUNT(DISTINCT f."film_id") AS "total_alquileres"
FROM "customer" c 
    JOIN "rental" r ON c."customer_id" = r."customer_id"
    JOIN "inventory" i ON r."inventory_id" = i."inventory_id" 
    JOIN "film" f ON i."film_id" = f."film_id" 
GROUP BY c."customer_id" 
HAVING COUNT(DISTINCT f."film_id") >= 7
ORDER BY c."last_name" ASC;


/*
61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
*/

SELECT 
    ca."name",
    COUNT("rental_id") AS "total_alquileres"
FROM "customer" c 
    JOIN "rental" r ON c."customer_id" = r."customer_id"
    JOIN "inventory" i ON r."inventory_id" = i."inventory_id" 
    JOIN "film" f ON i."film_id" = f."film_id" 
    JOIN "film_category" fc ON f."film_id" = fc."film_id"
    JOIN "category" ca ON fc."category_id" = ca."category_id" 
GROUP BY ca."name";


/*
62. Encuentra el número de películas por categoría estrenadas en 2006.
*/

SELECT 
    c."name" AS "category_name",
    COUNT(f."film_id") AS "total_peliculas"
FROM "film" f 
    JOIN "film_category" fc ON f."film_id" = fc."film_id" 
    JOIN "category" c ON fc."category_id" = c."category_id" 
WHERE f."release_year" = 2006
GROUP BY c."name";


/*
63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
*/

SELECT 
    CONCAT(s."first_name", ' ', s."last_name") AS "nombre_trabajador",
    s2."store_id"
FROM "staff" s 
CROSS JOIN "store" s2;


/*
64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
*/

SELECT 
    c."customer_id", 
    CONCAT(c."first_name", ' ', c."last_name") AS "nombre_cliente",
    COUNT(i."film_id") AS "total_peliculas"
FROM "customer" c 
    JOIN "rental" r ON c."customer_id" = r."customer_id" 
    JOIN "inventory" i ON r."inventory_id" = i."inventory_id" 
GROUP BY c."customer_id", c."first_name", c."last_name";





