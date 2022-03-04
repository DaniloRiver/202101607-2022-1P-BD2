select * from bd_factsv2.tbl_productos_facturados;
select * from bd_factsv2.tbl_productos;
DROP PROCEDURE bd_sample.SP_GUARDAR_FACTURA;

DELIMITER //
# crear procedimiento
CREATE PROCEDURE bd_sample.SP_GUARDAR_FACTURA(
	in p_idFactura      	int, 
	in p_idProducto         int,
    in p_cantidad           int     
  
)

BEGIN
#definir variables

declare v_idFactura      	int;
declare v_idPago            int;
declare v_cantidad          int;
declare v_impuestosobreventa  decimal(12,2) default 0;
declare v_precioVenta          decimal(12,2) default 0;
declare v_saldoUnidades   int default 0;



 #asignar valores de parametros a variables 
    set v_idFactura 	   = p_idFactura;
    set v_idProducto       = p_idProducto;
    set v_cantidad 	       = p_cantidad;
    
    
#controlador if
	select p.saldoUnidades into v_saldoUnidades 
    from bd_factsv2.tbl_productos as p 
    left join bd_factsv2.tbl_facturas as f
    on p.idProducto = f.idProducto
	where p.idFactura= v_idFactura;

	if ( v_saldoUnidades >= V_cantidad) then  
	# crear factura
        
         select precio_venta into v_precio_prod  
		 from bd_sample.tbl_productos 
		 where id_producto = v_id_producto; 
         
		 set v_numero_items = p_cantidad;
         set v_subtotal    = p_cantidad*v_precio_prod;
         set v_isv_total   = v_subtotal*0.15;
         set v_totapagar   = v_subtotal*1.15;
         
		 insert into bd_factsv2.tbl_productos_facturados (
		   idProducto, idFactura, cantidad, impuestosobreventa, precioVenta
		 )values(
			v_idProducto, v_idFactura,v_cantidad, v_impuestosobreventa, v_precioVenta
		 );
	else
	   insert bd_sample.tbl_items_factura (id_factura,id_producto,cantidad)
		values (v_id_factura,v_id_producto,v_cantidad);
		
		select sum(cantidad) into v_numero_items
		from bd_sample.tbl_items_factura 
		where id_factura = v_id_factura; 

		select precio_venta into v_precio_prod  
		from bd_sample.tbl_productos 
		where id_producto = v_id_producto; 

		update  bd_sample.tbl_facturas
		Set numero_items = v_numero_items,
			fecha_emision =v_fecha_emision,
			isv_total   = (subtotal + v_precio_prod * v_cantidad)*0.15,
			subtotal    =  subtotal + v_precio_prod * v_cantidad,
		    totapagar   = (subtotal)*1.15
		where id_factura = v_id_factura;
	end if;
 
 commit;
END;


# Ejecutar procedimiento 
CALL bd_sample.SP_GUARDAR_FACTURA(
	43, 					# p_id_factura  
	curdate(),    			# p_fecha_emision 
	3 ,				        # p_id_producto
	2                     # p_cantidad
);

#Buscar id subscriptor

select * 
from bd_sample.tbl_facturas
where fecha_emision =(select max(fecha_emision)
from bd_sample.tbl_facturas) and id_subscriptor=12;

select * 
from bd_sample.tbl_items_factura;