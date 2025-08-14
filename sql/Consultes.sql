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

/*
18. Selecciona todos los nombres de las películas únicos.
*/

SELECT DISTINCT "title"
FROM "film";

/*
 19. Encuentra el título de las películas que son comedias y tienen una
duración mayor a 180 minutos en la tabla “film”.
*/

SELECT f.title
FROM film f
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category c 
ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180; --Aplicamos las condiciones de filtrado

/*
 20. Encuentra las categorías de películas que tienen un promedio de
duración superior a 110 minutos y muestra el nombre de la categoría
junto con el promedio de duración. 
 */

SELECT c.name, ROUND(AVG(f.length),2) AS promedio_duracion
FROM category c
INNER JOIN film_category fc 
ON c.category_id = fc.category_id
INNER JOIN film f 
ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110; --Utilizamos HAVING por ser una función de agregación

/*
21. ¿Cuál es la media de duración del alquiler de las películas?
 */

SELECT AVG(return_date - rental_date) AS media_dias
FROM rental;

/*
22. Crea una columna con el nombre y apellidos de todos los actores y
actrices.
 */

SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo -- Unimos el nombre y apellido con la función CONCAT
FROM actor;

/*
23. Números de alquiler por día, ordenados por cantidad de alquiler de
forma descendente.
 */

SELECT rental_date::date AS fecha, COUNT(*) AS total_alquileres -- Utilizamos ::date para convertir el valor en solo fecha (año/mes/dia)
FROM rental
GROUP BY fecha -- Agrupamos por dias
ORDER BY total_alquileres DESC;

/*
24. Encuentra las películas con una duración superior al promedio.
 */

SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film); --Utilizamos la subconsulta para calcular el promedio de duración de las pelis

/*
25. Averigua el número de alquileres registrados por mes.
 */

SELECT DATE_TRUNC('month', rental_date)::date AS mes, COUNT(rental_id) AS total -- Truncamos todas las fechas y nos quedamos con el mes y año
FROM rental
GROUP BY mes
ORDER BY mes;

/*
26. Encuentra el promedio, la desviación estándar y varianza del total
pagado.
 */

SELECT ROUND(AVG(amount),2) AS promedio, ROUND(STDDEV(amount),2) AS desviacion, ROUND(VARIANCE(amount),2) AS varianza
FROM payment;

/*
27. ¿Qué películas se alquilan por encima del precio medio?
 */

SELECT title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);

/*
28. Muestra el id de los actores que hayan participado en más de 40
películas.
 */

SELECT actor_id, COUNT(actor_id) AS total_peliculas --Contamos las filas donde la columna "actor_id" es NO NULL
FROM film_actor
GROUP BY actor_id -- Agrupamos por actores
HAVING COUNT(actor_id) > 40;--Utilizamos HAVING por ser función de agregación

/*
29. Obtener todas las películas y, si están disponibles en el inventario,
mostrar la cantidad disponible.
 */

SELECT f.title, COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
RIGHT JOIN inventory i --El RIGHT nos asegura que la peli esté en el inventario. Al utilizar LEFT vemos que algunas tienen 0 unidades en inventario
ON f.film_id = i.film_id
GROUP BY f.title;

/*
30. Obtener los actores y el número de películas en las que ha actuado.
 */

SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

/*
31. Obtener todas las películas y mostrar los actores que han actuado en
ellas, incluso si algunas películas no tienen actores asociados.
 */

SELECT f.title, a.first_name, a.last_name
FROM film f
LEFT JOIN film_actor fa -- LEFT para mostrar las pelis incluso sin actores asociados
ON f.film_id = fa.film_id
LEFT JOIN actor a -- este LEFT asegura que aparezcan todas las pelis (aunque obtengamos un primer NULL)
ON fa.actor_id = a.actor_id;

/*
32. Obtener todos los actores y mostrar las películas en las que han
actuado, incluso si algunos actores no han actuado en ninguna película.
 */

SELECT a.first_name, a.last_name, f.title
FROM actor a
LEFT JOIN film_actor fa 
ON a.actor_id = fa.actor_id
LEFT JOIN film f 
ON fa.film_id = f.film_id;

/*
33. Obtener todas las películas que tenemos y todos los registros de
alquiler.
 */

SELECT f.title, r.* -- r.* selecciona todas las columnas de la tabla rental (alquileres)
FROM film f
FULL JOIN inventory i 
ON f.film_id = i.film_id
FULL JOIN rental r 
ON i.inventory_id = r.inventory_id;

/*
34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
 */

SELECT c.first_name, c.last_name, SUM(p.amount) AS gasto_total
FROM customer c
INNER JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY gasto_total DESC
LIMIT 5;

/*
35. Selecciona todos los actores cuyo primer nombre es 'Johnny'
 */

SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = 'JOHNNY';

/*
36. Renombra la columna “first_name” como Nombre y “last_name” como
Apellido.
 */

SELECT first_name AS Nombre, last_name AS Apellido
FROM actor;

/*
37. Encuentra el ID del actor más bajo y más alto en la tabla actor
 */

SELECT MIN(actor_id) AS id_min, MAX(actor_id) AS id_max
FROM actor;

/*
38. Cuenta cuántos actores hay en la tabla “actor”
 */

SELECT COUNT(actor_id) AS total_actores
FROM actor;

/*
39. Selecciona todos los actores y ordénalos por apellido en orden
ascendente.
 */

SELECT first_name, last_name 
FROM actor
ORDER BY last_name ASC;

/*
40. Selecciona las primeras 5 películas de la tabla “film”.
 */

SELECT title
FROM film
LIMIT 5;

/*
41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el
mismo nombre. ¿Cuál es el nombre más repetido?
 */

SELECT first_name, COUNT(actor_id) AS cantidad
FROM actor
GROUP BY first_name
ORDER BY cantidad DESC;

-- Nombres + repetidos: KENNETH, PENELOPE y JULIA

/*
42. Encuentra todos los alquileres y los nombres de los clientes que los
realizaron.
 */

SELECT r.rental_id , c.first_name, c.last_name
FROM rental r
INNER JOIN customer c 
ON r.customer_id = c.customer_id;

/*
43. Muestra todos los clientes y sus alquileres si existen, incluyendo
aquellos que no tienen alquileres.
 */

SELECT c.first_name, c.last_name, r.rental_id
FROM customer c
LEFT JOIN rental r 
ON c.customer_id = r.customer_id;

/*
44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
esta consulta? ¿Por qué? Deja después de la consulta la contestación.
 */

SELECT f.title, c.name
FROM film f
CROSS JOIN category c;

/*
No aporta nada de valor. La consulta nos devuelve el producto cartesiano de todas las posibles combinaciones entre las tablas.
La película ACADEMY DINOSAUR aparece con todas las categorías posibles cuando esta peli solo pertenece a una categoría (en este caso a la categoria 
Documentary). 
 */

/*
45. Encuentra los actores que han participado en películas de la categoría
'Action'.
 */

SELECT DISTINCT a.first_name, a.last_name -- DISTINCT se usa para evitar duplicados ya que un actor puede salir en varias pelis de 'Action'
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
INNER JOIN film_category fc 
ON fa.film_id = fc.film_id
INNER JOIN category c 
ON fc.category_id = c.category_id
WHERE c.name = 'Action';

/*
46. Encuentra todos los actores que no han participado en películas.
 */

SELECT a.first_name, a.last_name 
FROM actor a
LEFT JOIN film_actor fa 
ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;
--Todos los actores han participado en alguna

/*
47. Selecciona el nombre de los actores y la cantidad de películas en las
que han participado
 */

SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name;

/*
48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres
de los actores y el número de películas en las que han participado.
 */

CREATE VIEW actor_num_peliculas AS
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name;

/*
49. Calcula el número total de alquileres realizados por cada cliente.
 */

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer c
INNER JOIN rental r 
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

/*
50. Calcula la duración total de las películas en la categoría 'Action'.
 */

SELECT SUM(f.length) AS duracion_total
FROM film f
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category c 
ON fc.category_id = c.category_id
WHERE c.name = 'Action';

/*
51. Crea una tabla temporal llamada “cliente_rentas_temporal” para
almacenar el total de alquileres por cliente.
 */

CREATE TEMP TABLE cliente_rentas_temporal AS
SELECT c.customer_id, COUNT(r.rental_id) AS total_rentas
FROM customer c
INNER JOIN rental r 
ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

/*
52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
películas que han sido alquiladas al menos 10 veces.
 */

CREATE TEMP TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS total_alquileres
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
INNER JOIN rental r 
ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

/*
53. Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película.
 */

SELECT DISTINCT f.title
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
INNER JOIN rental r 
ON i.inventory_id = r.inventory_id
INNER JOIN customer c 
ON r.customer_id = c.customer_id
WHERE c.first_name = 'TAMMY' AND c.last_name = 'SANDERS' AND r.return_date IS NULL
ORDER BY f.title;

/*
54. Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
alfabéticamente por apellido.
 */

SELECT DISTINCT a.first_name, a.last_name --Utilizamos DISTINCT porque un actor puede haber actuado en varias pelis de 'Sci-Fi'
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
INNER JOIN film_category fc 
ON fa.film_id = fc.film_id
INNER JOIN category c 
ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name;

/*
55. Encuentra el nombre y apellido de los actores que han actuado en
películas que se alquilaron después de que la película ‘Spartacus
Cheaper’ se alquilara por primera vez. Ordena los resultados
alfabéticamente por apellido.
 */

SELECT DISTINCT a.first_name, a.last_name
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
INNER JOIN film f 
ON fa.film_id = f.film_id
INNER JOIN inventory i 
ON f.film_id = i.film_id
INNER JOIN rental r 
ON i.inventory_id = r.inventory_id
WHERE r.rental_date > ( -- Utilizamos subconsulta de WHERE para que se cumpla la condición del enunciado
    SELECT MIN(r2.rental_date)
    FROM film f2
    INNER JOIN inventory i2 
    ON f2.film_id = i2.film_id
    INNER JOIN rental r2 
    ON i2.inventory_id = r2.inventory_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name;

/*
56. Encuentra el nombre y apellido de los actores que no han actuado en
ninguna película de la categoría ‘Music’.
 */

SELECT DISTINCT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN ( --Utilizamos NOT IN pq la subconsulta nos devuelve los actores que SI que han actuado en pelis de la categoría 'Music'
    SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film_category fc 
    ON fa.film_id = fc.film_id
    INNER JOIN category c 
    ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
);

/*
57. Encuentra el título de todas las películas que fueron alquiladas por más
de 8 días
 */

SELECT DISTINCT f.title --DISTINCT para evitar duplicados de pelis que se han alquilado más de una vez por 8 días
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
INNER JOIN rental r 
ON i.inventory_id = r.inventory_id
WHERE EXTRACT(DAY FROM(r.return_date - r.rental_date))::int > 8; -- (r.return_date - r.rental_date) nos da un intervalo y NO puede compararlo con el entero 8
-- Por eso obtenemos los dias del intervalo, lo convertimos en entero y ya comparamos si es mayor que 8

/*
58. Encuentra el título de todas las películas que son de la misma categoría
que ‘Animation’.
 */

SELECT DISTINCT f.title
FROM film f
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
WHERE fc.category_id = (
    SELECT category_id 
    FROM category 
    WHERE name = 'Animation'
);

/*
59. Encuentra los nombres de las películas que tienen la misma duración
que la película con el título ‘Dancing Fever’. Ordena los resultados
alfabéticamente por título de película.
 */

SELECT title, length
FROM film
WHERE length = (SELECT length 
				FROM film 
				WHERE title = 'DANCING FEVER')
ORDER BY title;

/*
60. Encuentra los nombres de los clientes que han alquilado al menos 7
películas distintas. Ordena los resultados alfabéticamente por apellido.
 */

SELECT c.first_name, c.last_name
FROM customer c
INNER JOIN rental r 
ON c.customer_id = r.customer_id
INNER JOIN inventory i 
ON r.inventory_id = i.inventory_id
INNER JOIN film f 
ON i.film_id = f.film_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT f.film_id) >= 7
ORDER BY c.last_name;

/*
61. Encuentra la cantidad total de películas alquiladas por categoría y
muestra el nombre de la categoría junto con el recuento de alquileres
 */

SELECT c.name, COUNT(r.rental_id) AS total_alquileres
FROM category c
INNER JOIN film_category fc 
ON c.category_id = fc.category_id
INNER JOIN film f 
ON fc.film_id = f.film_id
INNER JOIN inventory i 
ON f.film_id = i.film_id
INNER JOIN rental r 
ON i.inventory_id = r.inventory_id
GROUP BY c.name;

/*
62. Encuentra el número de películas por categoría estrenadas en 2006
 */

SELECT c.name, COUNT(f.film_id) AS total
FROM category c
INNER JOIN film_category fc 
ON c.category_id = fc.category_id
INNER JOIN film f 
ON fc.film_id = f.film_id
WHERE  f.release_year = 2006
GROUP BY c.name;

/*
63. Obtén todas las combinaciones posibles de trabajadores con las tiendas
que tenemos.
 */
--Al pedirnos todas las posibles combinacioines, utilizamos el CROSS JOIN
--Para obtener el producto cartesiano de los trabajadores con las tiendas

SELECT s.first_name, s.last_name, st.store_id
FROM staff s
CROSS JOIN store st;

/*
64. Encuentra la cantidad total de películas alquiladas por cada cliente y
muestra el ID del cliente, su nombre y apellido junto con la cantidad de
películas alquiladas.
 */

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_peliculas
FROM customer c
INNER JOIN rental r 
ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;





