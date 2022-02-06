/* 1. Transacción para crear un nuevo subscriptor con los siguientes datos:
Codigo_subscriptor: 202212345
Nombres: Jon Paul
Apellidos: Doe
*/
SELECT * FROM bd_sample.tbl_subscriptores;
INSERT INTO bd_sample.tbl_subscriptores(codigo_subscriptor,nombres,apellidos) VALUES('202212345','Jon Paul','Doe');
SELECT * FROM bd_sample.tbl_subscriptores WHERE  codigo_subscriptor= 202212345;

############################################################################################
/*
2. Transacción para crear un nuevo proceso de compra para generar la factura y productos facturados para un subscriptor.
 */
 ##########################################################################################
 /*# variables Ejecución 1:
set @v_id_subscriptor= 16; 
set @v_id_factura= null;
set @v_id_producto = 2;
set @v_cantidad = 2;
set @v_numero_items = 0;
set @v_precio_prod = 0;*/

 # variables Ejecución 2:
set @v_id_subscriptor= 16; 
set @v_id_factura= null;
set @v_id_producto = 3;
set @v_cantidad = 2;
set @v_numero_items = 0;
set @v_precio_prod = 0;
 ###########################################################################################
 # 1. crear la factura.
 /*
 insert into bd_sample.tbl_facturas (
   id_factura, fecha_emision, id_subscriptor, numero_items, isv_total, subtotal, totapagar
 )values(
    null, curdate(),@v_id_subscriptor,0,0,0,0
 );
 */
 
 select last_insert_id() into  @v_id_factura ;
 
 ###########################################################################################
 
 # 2. Agregar el producto a los items de factura.
 insert into bd_sample.tbl_items_factura(
   id_factura, id_producto, cantidad
 )values( @v_id_factura, @v_id_producto, @v_cantidad);
 
 ############################################################################################
 
 #3. Actualizar resumen de facturas
 select sum(cantidad) into @v_numero_items
 from bd_sample.tbl_items_factura 
 where id_factura= @v_id_factura;
 
 select precio_venta into @v_precio_prod 
 from bd_sample.tbl_productos 
 where id_producto= @v_id_producto;
 
 update bd_sample.tbl_facturas
 set numero_items = @v_numero_items,
     isv_total = (@v_precio_prod*@v_numero_items)*0.18,
     subtotal = @v_precio_prod*@v_numero_items,
     totapagar = (@v_precio_prod*@v_numero_items)*1.18
	where id_factura =  @v_id_factura;
    
    
    
commit;
 ############################################################################################
 
 
SELECT * FROM bd_sample.tbl_subscriptores;
SELECT * FROM bd_sample.tbl_facturas where id_subscriptor = 16;

select * 
from bd_sample.tbl_facturas
where id_subscriptor = 16
and date_format(fecha_emision,'%Y%m') ='202202';

select * from bd_sample.tbl_items_factura where id_factura = 31

######################## RESPUESTAS ############################
/* 
¿Cuál es el monto total de las facturas creadas para el subscriptor con código: 202212345?
Ejecucion 1, Monto Total: factura#31 , 12.98
Ejecucion 2, Monto Total: factura#32 , 22.48

Nombre: jose danilo rivera 202101607
*/
