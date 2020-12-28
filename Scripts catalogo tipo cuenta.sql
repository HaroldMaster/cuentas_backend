--Insert de registro en cl_tabla para tipos de cuenta
insert into cl_tabla (codigo, tabla, descripcion) values ((select max(codigo)+1 from cl_tabla), 'g5_cl_tipo_cuenta','G5 Tipos de cuenta')
--Insert de registro en cl_catalogo para tipos de cuenta
insert into cl_catalogo (tabla, codigo, valor, estado) values (14996, 'A','Ahorros','V');
insert into cl_catalogo (tabla, codigo, valor, estado) values (14996, 'C','Corriente','V');
