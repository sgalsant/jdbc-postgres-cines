\connect bdcines;

create view cines.entradas_ex as
SELECT
    c.cine_id as cine_id,
	c.nombre as cine,
	f.funcion_id as funcion_id,
	f.fecha_hora as fecha_hora,
	s.sala_id as sala_id,
	s.nombre as sala,
	p.pelicula_id as pelicula_id,
	p.titulos -> 'es' as pelicula,
	cl.cliente_id as cliente_id,
	cl.nombre as cliente,
	e.entrada_id as entrada_id,
	e.precio as precio,
	e.fecha_compra as fecha_compra,
    ARRAY_AGG(a.numero) AS asientos
FROM
    cines.entradas e
	   INNER JOIN cines.clientes cl using (cliente_id)
	   INNER JOIN cines.funciones f using (funcion_id)
	   INNER JOIN cines.salas s using (sala_id)
	   INNER JOIN cines.cines c using (cine_id)
	   INNER JOIN cines.peliculas p using (pelicula_id)
	   INNER JOIN cines.asientos a using (entrada_id)
GROUP BY
	c.cine_id, cine,
	f.funcion_id, fecha_hora,
	s.sala_id, sala,
	p.pelicula_id, pelicula,
	cl.cliente_id, cliente,
	e.entrada_id, e.fecha_compra, precio;




-- Una vista con todos los datos de las funciones, incluyendo un array de asientos reservados

CREATE VIEW cines.funciones_ex AS
SELECT
	c.nombre as cine,
	s.nombre as sala,
	f.fecha_hora as fecha_hora,
	p.titulos -> 'es' as pelicula,
	s.capacidad as capacidad,
    ARRAY_AGG(a.numero) AS asientos_reservados,
	capacidad - ARRAY_LENGTH(ARRAY_AGG(a.numero), 1) as numero_asientos_libres
FROM
	funciones f
		inner join cines.salas s using (sala_id)
		inner join cines.cines c using (cine_id)
	    inner join cines.peliculas p using (pelicula_id)
    	left JOIN cines.asientos a using (funcion_id)
GROUP BY
    c.nombre,
	s.nombre,
	f.fecha_hora,
	pelicula,
	s.capacidad