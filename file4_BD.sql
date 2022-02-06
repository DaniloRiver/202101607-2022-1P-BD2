set @tasa=24.5;

select
id_factura,
fecha_emision,
totapagar totalusd,
round(totapagar*@tasa,2) totallps
from bd_sample.tbl_facturas;