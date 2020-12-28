USE cobis
GO
IF OBJECT_ID ('dbo.g5_busqueda_cliente') IS NOT NULL
	DROP PROCEDURE dbo.g5_busqueda_cliente
GO

CREATE PROCEDURE dbo.g5_busqueda_cliente
   @s_srv           varchar(30) = NULL,
   @s_ssn           int         = NULL,
   @s_ssn_branch    int         = 0,
   @s_date          datetime    = NULL,
   @s_ofi           smallint    = NULL,
   @s_user          varchar(30) = NULL,
   @s_lsrv          varchar(30) = NULL,
   @s_rol           smallint    = 1,
   @s_term          varchar(10) = NULL,
   @s_org           char(1)     = NULL,
   @s_culture       varchar(10) = 'NEUTRAL',
   @t_file          varchar(14) = NULL,
   @i_operacion     char(1),
   @t_trn            INT =99,
   @i_nombre		VARCHAR(30) = NULL,
   @i_apellido		VARCHAR(30) = NULL,     
  -- @i_telefono		VARCHAR(30) = NULL,
   @i_cedula		VARCHAR(30) = NULL,
  -- @i_nacionalidad	VARCHAR(30) = NULL,
   @i_id			INT			= NULL
AS
if @i_operacion='S'
    begin
		select cl_cedula, 
			   cl_nombre, 
			   cl_apellido, 
			   cl_id 
			   from cliente_taller 
			   where cl_cedula = @i_cedula;
	end
return 0