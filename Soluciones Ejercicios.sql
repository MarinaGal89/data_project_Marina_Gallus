/*
2. Muestra los nombres de todas las películas con una clasificación por
edades de ‘R.
*/

select "title"
from "film"
where "rating" = 'R';


/*
3. Encuentra los nombres de los actores que tengan un “actor_id entre 30
y 40.
*/

select concat(first_name,' ', last_name ) as nombreapellido_actor, "actor_id"
from "actor"
where "actor_id" between 30 and 40


/*
4. Obtén las películas cuyo idioma coincide con el idioma original.
*/

select film_id, title
from film
where language_id = original_language_id;


/*
5. Ordena las películas por duración de forma ascendente.
*/

select "film_id", "title","length"
from "film"
order by "length" asc;


/*
 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen en su
apellido.
 */

select "first_name", "last_name"
from "actor"
where "last_name" = 'ALLEN';


/*
 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.
 */

select  "rating", count ("rating") as "numero_peliculas"
from "film"
group by "rating";


/*
 8. Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una duración mayor a 3 horas en la tabla film.
 */

select "title", "rating", "length"
from "film"
where "rating" = 'PG-13' or "length" > 180;


/*
 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
 */

select round (variance ("replacement_cost"), 2) as "varianza_remplazo"
from "film";


/*
 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
 */

select min (length) as "menor_duración",  max (length) as "mayor_duración"
from "film";


/*
 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
 */

select amount, payment_date
from payment
order by payment_date DESC
offset 2 limit 1;


/*
 12. Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC 17ʼ ni ‘Gʼ en cuanto a su clasificación.
 */

select "title", "rating"
from "film"
where "rating" not in ('NC-17', 'G');


/*
13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
*/

select "rating", round (AVG ("length")) as "duración_promedio"
from "film"
group by "rating";


/*
 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
 */

select "title", "length"
from "film"
where "length" > 180; 


/*
 15. ¿Cuánto dinero ha generado en total la empresa?
 */

select round( sum ("amount"), 2) as "facturación_empresa"
from "payment";


/*
 16. Muestra los 10 clientes con mayor valor de id.
 */

select  "customer_id", concat ("first_name", ' ', "last_name") as "nombre_cliente"
from "customer"
order by "customer_id" desc
limit 10;


/*
 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
 */

select concat ("first_name", ' ',"last_name") as "actor_name"
from "actor"
where "actor_id" in (

select "actor_id"
from "film_actor"
where "film_id" in (
  
select "film_id"
from "film"
where "title" = 'EGG IGBY') );


/*
 18. Selecciona todos los nombres de las películas únicos.
 */


select distinct "title"
from "film";


/*
 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.
 */

create view tabla_titulopelicula_categoria as 
select 
f."film_id",
f."title"as titulo_pelicula,
c."name",
f."length"
from "film" f
    inner join "film_category" fc
    on f."film_id" = fc."film_id"
    inner join "category" c
    on fc."category_id" = c."category_id";
    
select *
from "tabla_titulopelicula_categoria"
where "name" = 'Comedy'
and "length" > 180;


/*
 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
 */

create view tabla_titulopelicula_categoria as 
select 
f."film_id",
f."title"as titulo_pelicula,
c."name",
f."length"
from "film" f
    inner join "film_category" fc
    on f."film_id" = fc."film_id"
    inner join "category" c
    on fc."category_id" = c."category_id";

select 
"name" as category_name,
round (avg ("length"), 0) as "duración_promedio"
from "tabla_titulopelicula_categoria"
group by "name"
having avg ("length") > 110;


/*
 21. ¿Cuál es la media de duración del alquiler de las películas?
 */

select ROUND(AVG(rental_duration), 2) as promedio_dias_alquiler
from film;


/*
 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
 */

select concat ("first_name", ' ', "last_name") as "nombre_actor"
from actor; 


/*
 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
 */

select 
   cast ("rental_date" as date) as "día_alquiler",
   count ("rental_id") as "alquileres_por_día"
from "rental"
group by "día_alquiler"
order by "alquileres_por_día" DESC;


/*
 24. Encuentra las películas con una duración superior al promedio.
 */

select "film_id", "title", "length"
from "film"
where "length" > (
select AVG (length)
from "film" ); 

/*
 25. Averigua el número de alquileres registrados por mes.
 */

select 
to_char ("rental_date", 'YYYY-MM"') as mes,
count (*) as "alquileres_mes"
from "rental"
group by to_char ("rental_date", 'YYYY-MM"')
order by "mes" ASC; 

/*
 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
 */

select 
round (AVG ("amount"), 2) as "promedio_pagado",
round (stddev ("amount"), 2) as "desviacion_std_pagado",
round (variance ("amount"), 2) as "varianza_pagado"
from "payment";

/*
27. ¿Qué películas se alquilan por encima del precio medio?
 */

create view precio_por_pelicula as
select 
f."film_id",
f."title",
p."amount",
r."rental_id",
i."inventory_id"
from "film" f 
    inner join "inventory" i 
    on f."film_id" = i."film_id"
    inner join "rental" r 
    on i."inventory_id" = r."inventory_id"
    inner join "payment" p 
    on p."rental_id" = r."rental_id";


with promedio_precio as (
select 
AVG ("amount") as "promedio"
from "precio_por_pelicula"
)
select 
"film_id",
"title",
round (AVG ("amount"), 2) as "precio_medio"
from "precio_por_pelicula"
group by "film_id", "title"
having round (AVG ("amount"), 2) > (select "promedio" from "promedio_precio");
    

/*
 28. Muestra el id de los actores que hayan participado en más de 40 películas.
 */

select actor_id, count(film_id) as total_peliculas
from film_actor
group by actor_id
having count(film_id) > 40
order by total_peliculas DESC;


/*
 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
 */

select 
    f."film_id",
    f."title",
    count(i."inventory_id") as copias_disponibles
from "film" f
left join "inventory" i 
on f."film_id" = i."film_id"
group by f."film_id", f."title"
order by f."title";


/*
 30. Obtener los actores y el número de películas en las que ha actuado.
 */

select 
a."actor_id",
concat ("first_name", ' ' , "last_name") as "nombre_apellido",
count (fa."film_id") as "total_peliculas"
from "actor" as a
left join "film_actor" as fa
on a."actor_id" = fa."actor_id" 
group by a."actor_id", a."first_name", a."last_name";


/*
 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
 */

select 
f."film_id",
f."title",
concat (a."first_name", ' ',a."last_name") as "actor_name"
from "film" f
    left join "film_actor" fa
    on f."film_id" = fa."film_id"
    left join "actor" a 
    on fa."actor_id" = a."actor_id"
order by f."film_id", "actor_name" ASC;



/* 
 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
 */

select 
a."actor_id",
concat (a."first_name", ' ',a."last_name") as "Nombre_Apellido_Actor",
f."film_id",
f."title" as film_title
from "actor" a
    left join "film_actor" fa
    on a."actor_id" = fa."actor_id"
    left join "film" f 
    on fa."film_id" = f."film_id"
order by a."actor_id", f."title" ASC;


/*
 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
 */

select 
f."film_id",
f."title" as film_title,
r."rental_id"
from "film" f
    left join "inventory" i
    on f."film_id" = i."film_id"
    left join "rental" r
    on i."inventory_id" = r."inventory_id"
order by f."film_id", r."rental_id";


/*
 34 Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
 */

select 
    c."customer_id",
    concat(c."first_name", ' ', c."last_name") as "customer_name",
    round(sum(p."amount"), 2) as "total_pagado"
from "customer" c
left join "payment" p ON c."customer_id" = p."customer_id"
group by c."customer_id", c."first_name", c."last_name"
order by "total_pagado" DESC
limit 5;


/*
 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
 */

select "actor_id", "first_name", "last_name"
from "actor"
where "first_name" = 'JOHNNY';


/*
 36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.
 */

select 
"actor_id",
"first_name" as "Nombre", 
"last_name" as "Apellido"
from "actor"
where "first_name" = 'JOHNNY';


/*
 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
 */

select 
min ("actor_id") as "Id_mas_bajo",
max ("actor_id") as "Id_mas_alto"
from "actor";


/*
 38. Cuenta cuántos actores hay en la tabla “actorˮ.
 */

select 
count ("actor_id") as "total_actores"
from "actor";


/*
 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
 */

select 
"actor_id",
"first_name",
"last_name"
from "actor"
order by "last_name" asc;

/*
 40. Selecciona las primeras 5 películas de la tabla “filmˮ.
 */

select 
"film_id",
"title"
from "film"
limit 5;

/*
 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
 */

select
"first_name",
count ("first_name") as "actores_por_nombre"
from "actor"
group by "first_name"
order by "actores_por_nombre" desc;

-- los nombres màs repetidos son 'Kenneth', 'Penelope' y 'Julia' -- 


/*
 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
 */

select 
r."rental_id",
concat (c."first_name", ' ', c."last_name") as "nombre_cliente"
from "rental" r
left join "customer" c
on r."customer_id" = c."customer_id";


/*
 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
 */

select 
concat (c."first_name", ' ', c."last_name") as "nombre_cliente",
r."rental_id"
from "customer" c
left join "rental" r
on c."customer_id" = r."customer_id"
order by "nombre_cliente";

/*
 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
 */

select *
from "film" f
cross join "category" c;

/*
 Esta consulta no aporta ningun valor. 
 A través de ella estamos realizando el producto cartesiano de las tablas Film y Category.
 El resultado es por ejemplo que al film con id '1' se le asigna la cada una de las categorias existentes en la tabla Category: si un film es comedia, no puede ser horror
 */


/*
 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
 */ 

select distinct 
    a."actor_id",
    concat(a."first_name", ' ', a."last_name") as "nombre_actor"
from "actor" a
    join "film_actor" fa on a."actor_id" = fa."actor_id"
    join "film" f on fa."film_id" = f."film_id"
    join "film_category" fc on f."film_id" = fc."film_id"
    join "category" c on fc."category_id" = c."category_id"
where c."name" = 'Action'
order by "nombre_actor";


/*
 46. Encuentra todos los actores que no han participado en películas.
 */

select
a."actor_id",
concat (a."first_name",' ', a."last_name") as "nombre_actor",
fa."film_id"
from "actor" a
left join "film_actor" fa
on a."actor_id" = fa."actor_id"
where fa."film_id" is null;


/*
 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
 */

select
a."actor_id",
concat (a."first_name",' ', a."last_name") as "nombre_actor",
count (fa."film_id") as "peliculas_por_actor"
from "actor" a
left join "film_actor" fa
on a."actor_id" = fa."actor_id"
group by a."actor_id", a."first_name", a."last_name"
order by "peliculas_por_actor" DESC;


/*
 48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.
 */


create view actor_num_peliculas as 
select
a."actor_id",
concat (a."first_name",' ', a."last_name") as "nombre_actor",
count (fa."film_id") as "peliculas_por_actor"
from "actor" a
left join "film_actor" fa
on a."actor_id" = fa."actor_id"
group by a."actor_id", a."first_name", a."last_name"
order by "peliculas_por_actor" DESC;



/*
 49. Calcula el número total de alquileres realizados por cada cliente.
 */

select
c."customer_id",
concat (c."first_name" , ' ', c."last_name") as "customer_name",
count(r."rental_id") as "total_alquileres"
from "customer" c 
    left join "rental" r 
    on c."customer_id" = r."customer_id"
group by c."customer_id", c."first_name", c."last_name"
order by "total_alquileres" DESC;


/*
 50. Calcula la duración total de las películas en la categoría 'Action'.
 */

create view "film_categoria" as
select 
f."film_id",
f."title",
fc."category_id",
c."name"
from "film" f
    inner join "film_category" fc
    on f."film_id" = fc."film_id"
    inner join "category" c
    on fc."category_id" = c."category_id";

select 
fca."name" as "categoria",
ROUND(SUM(f."length"), 2) as "duracion_total"
from "film" f 
   inner join "film_categoria" fca
   on f."film_id" = fca."film_id"
where fca."name" = 'Action'
group by fca."name";


/*
 51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.
 */

create temporary table cliente_rentas_temporal as
select 
    c."customer_id",
    concat(c."first_name", ' ', c."last_name") as "nombre_cliente",
    count(r."rental_id") as "total_alquileres"
from "customer" c
left join "rental" r ON c."customer_id" = r."customer_id"
group by c."customer_id", c."first_name", c."last_name"
order by "total_alquileres" DESC;


/*
 52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.
 */

create temporary table “peliculas_alquiladasˮ as
select 
f."film_id",
f."title",
count (r."rental_id") as total_alquileres
from film f 
    join "inventory" i 
    on f."film_id" = i."film_id"
    join "rental" r 
    on i."inventory_id" = r."inventory_id" 
group by f."film_id", f."title"
having count (r."rental_id") >= 10 ;
 

/*
 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
 */

select 
concat(c.first_name,' ', c.last_name) as nombre_cliente,
f.title ,
r.return_date 
from customer c 
    inner join rental r 
    on c.customer_id = r.customer_id 
    inner join inventory i 
    on r.inventory_id = i.inventory_id 
    inner join film f 
    on i.film_id = f.film_id 
where c.first_name = 'TAMMY'
and c.last_name = 'SANDERS'
and r.return_date is null
order by f.title asc;

/*
 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados alfabéticamente por apellido.
 */

select distinct 
a.actor_id,
a.last_name,
a.first_name


from category c 
    inner join film_category fc 
    on c.category_id = fc.category_id 
    inner join film f 
    on fc.film_id = f.film_id 
    inner join film_actor fa 
    on f.film_id = fa.film_id 
    inner join actor a 
    on fa.actor_id = a.actor_id
    
where c.name = 'Sci-Fi'
order by a.last_name;
 

/*
 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
 */

select distinct
    concat (a.first_name, ' ', a.last_name) as nombre_actor

from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
where r.rental_date > (
    select min(r2.rental_date)
    from rental r2
    join inventory i2 on r2.inventory_id = i2.inventory_id
    join film f2 on i2.film_id = f2.film_id
    where f2.title = 'SPARTACUS CHEAPER'
)
order by nombre_actor;


/*
56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ.
*/
    
   select 
   a.first_name,
   a.last_name
   
   from actor a 
   
   where not exists (
   select 1
   from film_actor fa 
   join film f on fa.film_id = f.film_id
   join film_category fc on f.film_id = fc.film_id
   join category c on fc.category_id = c.category_id 
   where fa.actor_id = a.actor_id and c.name = 'Music');
   
    
/*
 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
 */

select f.title
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
where date_part('day', r.return_date - r.rental_date) > 8;
   
   
/*
58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ.
*/

select f.title
from film f 
join film_category fc on f.film_id = fc.film_id 
join category c on fc.category_id = c.category_id 
where c.category_id = (

select category_id 
from category c 
where "name" = 'Animation');


/*
59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. Ordena los resultados alfabéticamente por título de película.
*/

select title
from film f 
where length = (

select length
from film f 
where title = 'DANCING FEVER')
order by title asc ;


/*
 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
 */

select 
concat (c.first_name,' ', c.last_name) as nombre_cliente,
count (distinct f.film_id) as total_alquileres
from customer c 
join rental r on c.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id 
join film f on i.film_id = f.film_id 
group by c.customer_id 
having count (distinct f.film_id) >= 7
order by c.last_name asc ;


/*
 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
 */ 

select 
ca."name" ,
count (rental_id) as total_alquileres
from customer c 
join rental r on c.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id 
join film f on i.film_id = f.film_id 
join film_category fc on f.film_id = fc. film_id
join category ca on fc.category_id = ca.category_id 
group by ca.name;


/*
62. Encuentra el número de películas por categoría estrenadas en 2006.
*/

select 
c."name" as category_name,
count (f.film_id) as total_peliculas
from film f 
join film_category fc on f.film_id = fc.film_id 
join category c on fc.category_id = c.category_id 
where f.release_year = 2006
group by c."name" ;


/*
63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
*/

select 
concat (s.first_name, ' ', s.last_name) as nombre_trabajador,
s2.store_id
from staff s 
cross join store s2 ;


/*
 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
 */

select 
c.customer_id, 
concat (c.first_name, ' ', c.last_name) as nombre_cliente,
count (i.film_id) as total_peliculas

from customer c 
join rental r on c.customer_id = r.customer_id 
join inventory i on r.inventory_id = i.inventory_id 
group by c.customer_id, c.first_name, c.last_name ;







