


SELECT * FROM bd_facts.tbl_asesores;
SELECT * FROM bd_facts.tbl_clientes;
SELECT * FROM bd_facts.tbl_facturas;

#################################################### Ejercicio 4 ######################################################
SELECT a.idAsesor, a.nombres FROM bd_facts.tbl_clientes AS c
LEFT JOIN bd_facts.tbl_asesores AS a
ON c.idAsesor = a.idAsesor
WHERE a.cantClientes = 0;
############################################## Ejercicio 5 ##########################################################
SELECT c.idCliente, c.nombrecompleto, f.idFactura,f.fechaEmision,f.fechaVencimiento, f.estado FROM bd_facts.tbl_facturas AS f
LEFT JOIN bd_facts.tbl_clientes AS c
ON f.idCliente = c.idCliente
WHERE f.estado = "PENDIENTE";


################################################# Ejercicio 6 ######################################################

 # variables Ejecución :
set @v_idAsesor = 14; 
set @v_idCliente = 101;
set @v_cantClientes = 0;

 # variables Ejecución :
set @v_idAsesor = 1; 
set @v_idCliente = 128;
set @v_cantClientes = 0;

# 1. Asignar asesor en la tabla cliente.

 
update bd_facts.tbl_clientes
set idAsesor = @v_idAsesor
where idCliente =  @v_idCliente;

### Actualizar el campo cantclientes en la tabla asesores, según la cantidad de clientes que tenga el asesor.

 select count(*) into @v_cantClientes
 from bd_facts.tbl_clientes
 where idAsesor = @v_idAsesor;
 
update bd_facts.tbl_asesores
set cantClientes = @v_cantClientes
where idAsesor =  @v_idAsesor; 

select * from bd_facts.tbl_clientes where idAsesor = 1;
select cantClientes from bd_facts.tbl_asesores where idAsesor = 1;

################################################# Ejercicio 7 ##########################################################

select c.idAsesor, count(a.cantClientes) as clientes 
from bd_facts.tbl_clientes as c
left join bd_facts.tbl_asesores as a
on c.idAsesor = a.idAsesor
group by idAsesor
having clientes >= 4




 



