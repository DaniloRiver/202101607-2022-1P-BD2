select * from bd_factsv2.tbl_productos_facturados;
select * from bd_factsv2.tbl_productos;
DROP PROCEDURE bd_sample.SP_FACTURA;

DELIMITER //
# crear procedimiento
CREATE PROCEDURE bd_factsv2.SP_FACTURA(
	in p_idFactura      	int, 
	in p_idProducto         int,
    in p_cantidad           int     
  
)

BEGIN
#definir variables

declare v_idFactura      	    int;
declare v_idProducto            int;
declare v_cantidad              int;
declare v_precioVenta           decimal(12,2) default 0;
declare v_saldo                int;




 #asignar valores de parametros a variables 
    set v_idFactura 	   = p_idFactura;
    set v_idProducto       = p_idProducto;
    set v_cantidad 	       = p_cantidad;
    
    select saldoUnidades into v_saldo  from bd_factsv2.tbl_productos where idProducto = v_idProducto;
 
#controlador if

	if  v_saldo  >= v_cantidad  then  
         
			 insert into bd_factsv2.tbl_productos_facturados (
			   idProducto, idFactura, cantidad
			 )values(
				v_idProducto, v_idFactura,v_cantidad
			 );
			 
			update  bd_factsv2.tbl_productos
			Set saldoUnidades = saldoUnidades - v_cantidad
			where idProducto = v_idProducto;
			
			select precioVenta into v_precioVenta 
			from bd_factsv2.tbl_productos 
			where idProducto = v_idProducto; 
			
			update  bd_factsv2.tbl_facturas
			Set cantidadProductos = cantidadProductos + v_cantidad,
				subTotalPagar = subTotalPagar + (v_precioVenta*v_cantidad),
				totalISV   = (subTotalPagar)*0.15,
				totalpagar  = (subtotal)*1.15
			where idFactura = v_idFactura;
        
		
	
	end if;
 
 commit;
END;

# Ejecutar procedimiento 
CALL bd_factsv2.SP_FACTURA(
	1004, 					# p_id_producto  
	6 ,				        # p_id_factura
	6                       # p_cantidad
);

#Buscar id subscriptor

select * from bd_factsv2.tbl_facturas
select * from bd_factsv2.tbl_productos_facturados;
select * from bd_factsv2.tbl_productos;







