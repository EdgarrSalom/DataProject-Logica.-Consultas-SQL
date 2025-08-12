/*
  2. Muestra los nombres de todas las películas con una clasificación por
edades de ‘R’
 */

SELECT "title"
FROM "film"
WHERE "rating" = 'R'; --Filtramos solo las que tienen una clasificación por edades = 'R'

/*
3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30
y 40.
*/

SELECT "first_name"
FROM "actor"
WHERE "actor_id" BETWEEN 30 AND 40;

/*
 4. Obtén las películas cuyo idioma coincide con el idioma original.
 */

SELECT "title"
FROM "film"
WHERE "language_id" = "original_language_id";
-- No obtenemos ninguna porque la columna "original_language_id" contiene todo NULL

/*
5. Ordena las películas por duración de forma ascendente.
*/

SELECT "title", "length"
FROM "film"
ORDER BY "length";

/*
6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su
apellido.
*/

SELECT "first_name", "last_name"
FROM "actor"
WHERE "last_name" = 'ALLEN';

/*
7. Encuentra la cantidad total de películas en cada clasificación de la tabla
“film” y muestra la clasificación junto con el recuento.
*/

SELECT "rating", COUNT(*) AS "total_peliculas"
FROM "film"
GROUP BY "rating";

/*
8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una
duración mayor a 3 horas en la tabla film.
*/

SELECT "title"
FROM "film"
WHERE "rating" = 'PG-13' OR "length" > 180;

/*
9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
*/

SELECT ROUND(VARIANCE("replacement_cost"),2) AS "variabilidad"
FROM "film";

/*
10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
*/

SELECT MAX("length") AS "duracion_maxima", MIN("length") AS "duracion_minima"
FROM "film";

/*
11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
*/

SELECT "amount"
FROM "payment"
ORDER BY "payment_date" DESC
LIMIT 1 OFFSET 2;

/*
12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.
*/

SELECT "title"
FROM "film"
WHERE "rating" NOT IN ('NC-17', 'G');

/*
13. Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración.
*/

SELECT "rating", ROUND(AVG("length"),2) AS "promedio_duracion"
FROM "film"
GROUP BY "rating";

/*
14. Encuentra el título de todas las películas que tengan una duración mayor
a 180 minutos.
*/

SELECT "title"
FROM "film"
WHERE "length" > 180;

/*
15. ¿Cuánto dinero ha generado en total la empresa?
*/

SELECT SUM("amount") AS "total_ingresos"
FROM "payment";

/*
16. Muestra los 10 clientes con mayor valor de id.
*/

SELECT "customer_id", "first_name", "last_name"
FROM "customer"
ORDER BY "customer_id" DESC
LIMIT 10;

/*
17. Encuentra el nombre y apellido de los actores que aparecen en la
película con título ‘Egg Igby’.
*/

SELECT a."first_name", a."last_name"
FROM "actor" a
INNER JOIN "film_actor" fa 
ON a."actor_id" = fa."actor_id"
INNER JOIN "film" f 
ON fa."film_id" = f."film_id"
WHERE f."title" = 'EGG IGBY';







