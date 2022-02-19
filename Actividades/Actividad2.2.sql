
########################## EjerciciO No1 ############################################
#Cree  procedimiento almacenado "sp_guardar_subscriptor" para actualizar los
# campos de un subscriptor existente en la base de datos.
select * from bd_sample.tbl_subscriptores;
DROP PROCEDURE bd_sample.SP_GUARDAR_SUBSCRIPTOR;
DELIMITER //
# crear procedimiento
CREATE PROCEDURE bd_sample.SP_GUARDAR_SUBSCRIPTOR(
	in p_id_subscriptor 	int, 
    in p_codigo_subscriptor int,
    in p_nombres 			varchar(25),
    in p_apellidos 			varchar(25)
)
BEGIN
#definir variables

declare v_id_subscriptor int;
declare v_codigo_subscriptor int;
declare v_nombres varchar(25);
declare v_apellidos varchar(45);

 #asignar valores de parametros a variables 
    set v_id_subscriptor 		= p_id_subscriptor;
	set v_codigo_subscriptor	= p_codigo_subscriptor; 
    set v_nombres				= p_nombres;
    set v_apellidos				= p_apellidos;
    
    
# Actualizar subscriptor
update bd_sample.tbl_subscriptores
set    codigo_subscriptor = v_codigo_subscriptor,
	   nombres = v_nombres, 
	   apellidos = v_apellidos
where  id_subscriptor = v_id_subscriptor;
     

 commit;
END;

# Ejecutar procedimiento 
CALL bd_sample.SP_GUARDAR_SUBSCRIPTOR(
	17, 					# p_id_subscriptor  
	202211111,    			# p_codigo_subscriptor 
    'LEONEL',				# p_nombres 			 
    'MARTINS' 				#p_apellidos 		 
);

#Buscar id subscriptor
select id_subscriptor, nombres, apellidos
from bd_sample.tbl_subscriptores
where id_subscriptor = 17;

########################## EjerciciO No2 ############################################
#Cree el procedimiento almacenado "sp_guardar_producto" para crear nuevos productos, 
#debe recibir los parámetros el nombre, la descripción y el precio de costo del producto.
# El precio de venta debe ser calculado en razón de un 125% del precio de costo. 

select * from bd_sample.tbl_productos;
DROP PROCEDURE bd_sample.SP_GUARDAR_PRODUCTO;

DELIMITER //
# crear procedimiento
CREATE PROCEDURE bd_sample.SP_GUARDAR_PRODUCTO(
	in p_id_producto 	    int, 
    in p_nombre             varchar(25),
    in p_descripcion 		varchar(25),
    in p_precio_costo 		decimal(12,2)
)
BEGIN
#definir variables

declare v_id_producto int;
declare v_nombre      varchar(25);
declare v_descripcion varchar(25);
declare v_precio_costo decimal(12,2);
declare v_precio_venta decimal(12,2);

 #asignar valores de parametros a variables 
    set v_id_producto    		= p_id_producto;
	set v_nombre            	= p_nombre; 
    set v_descripcion			= p_descripcion;
    set v_precio_costo			= p_precio_costo;
    set v_precio_venta          = p_precio_costo*1.125;
    
 # crear nuevo producto
insert into bd_sample.tbl_productos(
   id_producto, nombre, descripcion, precio_costo, precio_venta
) values (
   v_id_producto, v_nombre, v_descripcion, v_precio_costo, v_precio_venta
);   

 commit;
END;

# Ejecutar procedimiento 
CALL bd_sample.SP_GUARDAR_PRODUCTO(
	0, 					    # p_id_producto  
	'Plan Elite',    		# p_nombre 
    'Plan Elite',			# p_descripcion 			 
     8				        #p_precio_costo
    
);

#Buscar id producto
select * 
from bd_sample.tbl_productos
where id_producto =(select max(id_producto)
from bd_sample.tbl_productos);

########################## EjerciciO No3 ############################################

#Cree el procedimiento almacenado "sp_guardar_factura" que registre una  
#nueva factura según los parámetros recibidos.

select * from bd_sample.tbl_facturas;
DROP PROCEDURE bd_sample.SP_GUARDAR_FACTURA;

DELIMITER //
# crear procedimiento
CREATE PROCEDURE bd_sample.SP_GUARDAR_FACTURA(
	in p_id_factura      	int, 
    in p_fecha_emision      datetime,
    in p_id_subscriptor 	int,
    in p_numero_items 		int,
    in p_isv_total          decimal(12,2),
    in p_subtotal           decimal(12,2),
    in p_totapagar          decimal(12,2)
)
BEGIN
#definir variables

declare v_id_factura      	int;
declare v_fecha_emision     datetime;
declare v_id_subscriptor 	int;
declare v_numero_items 		int;
declare v_isv_total         decimal(12,2);
declare v_subtotal          decimal(12,2);
declare v_totapagar         decimal(12,2);


 #asignar valores de parametros a variables 
    set v_id_factura 		= p_id_factura;
	set v_fecha_emision	    = p_fecha_emision; 
    set v_id_subscriptor	= p_id_subscriptor;
    set v_numero_items 		= p_numero_items;
    set v_isv_total         = p_isv_total;
    set v_subtotal          = p_subtotal;
    set v_totapagar         = p_totapagar;
    
# crear factura

 insert into bd_sample.tbl_facturas (
   id_factura, fecha_emision, id_subscriptor, numero_items, isv_total, subtotal, totapagar
 )values(
    v_id_factura, v_fecha_emision,v_id_subscriptor,v_numero_items,v_isv_total,v_subtotal,v_totapagar
 );
 
 
 commit;
END;

# Ejecutar procedimiento 
CALL bd_sample.SP_GUARDAR_FACTURA(
	null, 					# p_id_factura  
	curdate(),    			# p_fecha_emision 
    14,				        # p_id_subscriptor			 
    0 ,				        # p_numero_items 
	0 ,				        # p_numero_items
	0 ,				        # p_numero_items
	0 				        # p_numero_items
);

#Buscar id subscriptor

select * 
from bd_sample.tbl_facturas
where fecha_emision =(select max(fecha_emision)
from bd_sample.tbl_facturas) and id_subscriptor=14;

########################## EjerciciO No4 ############################################
#Cree el procedimiento almacenado "sp_procesar_factura " que registre el proceso de facturación:
# Registra un producto de acuerdo un numero de factura en la tabla ítems factura
# Actualiza los valores de la factura con los valores totales

select * from bd_sample.tbl_items_factura;
select * from bd_sample.tbl_facturas;
DROP PROCEDURE bd_sample.SP_PROCESAR_FACTURA;

DELIMITER //
# crear procedimiento
CREATE PROCEDURE bd_sample.SP_PROCESAR_FACTURA(
	in p_id_factura      	int, 
    in p_id_producto        int,
    in p_cantidad 	        int
)
BEGIN
#definir variables

declare v_id_factura      	int;
declare v_id_producto       int;
declare v_cantidad 	        int;
declare v_numero_items      int;


 #asignar valores de parametros a variables 
    set v_id_factura 		= p_id_factura;
	set v_id_producto	    = p_id_producto; 
    set v_cantidad      	= p_cantidad;
    set v_numero_items      = 0;
  
 # 1. Registra un producto de acuerdo un numero de factura en la tabla ítems factura.
 insert into bd_sample.tbl_items_factura(
   id_factura, id_producto, cantidad
 )values( v_id_factura, v_id_producto, v_cantidad);
 
 #3. Actualizar resumen de facturas
 select sum(v_cantidad) into v_numero_items
 from bd_sample.tbl_items_factura 
 where id_factura= v_id_factura;
 
 update bd_sample.tbl_facturas
 set numero_items = v_numero_items
	where id_factura =  v_id_factura;
 
 commit;
END;

# Ejecutar procedimiento 
CALL bd_sample.SP_PROCESAR_FACTURA(
    32, 					# p_id_factura 
	2,					    # p_id_producto
	2					    # p_cantidad

);

#Buscar factura actualizada
select * 
from bd_sample.tbl_facturas
where id_factura=32;



