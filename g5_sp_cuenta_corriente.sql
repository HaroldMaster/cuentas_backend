USE COBIS
GO

IF OBJECT_ID ('dbo.g5_sp_cuenta_corriente') IS NOT NULL
	DROP PROCEDURE dbo.g5_sp_cuenta_corriente
GO

CREATE PROCEDURE g5_sp_cuenta_corriente
   @s_srv           		varchar(30) = NULL,
   @s_ssn           		int         = NULL,
   @s_ssn_branch    		int         = 0,
   @s_date          		datetime    = NULL,
   @s_ofi           		smallint    = NULL,
   @s_user          		varchar(30) = NULL,
   @s_lsrv					varchar(30) = NULL,
   @s_rol					smallint    = 1,
   @s_term					varchar(10) = NULL,
   @s_org					char(1)     = NULL,
   @s_culture				varchar(10) = 'NEUTRAL',
   @t_file					varchar(14) = NULL,
   @i_operacion				char(1),
   @t_trn					INT =99,
   @i_banco					VARCHAR(30) = NULL,
   @i_fecha_creacion		VARCHAR(30) = NULL,     
   @i_fecha_modificacion	VARCHAR(30) = NULL,
   @i_cliente				VARCHAR(30) = NULL,
   @i_saldo					float = NULL
   
  
AS
    declare @w_sp_name       varchar(14)
    DECLARE @w_numero_cuenta VARCHAR(10)
            
   	select @w_sp_name = 'g5_sp_cuenta_corriente'
   
            
    IF @i_operacion='I'
    BEGIN
    	SELECT @w_numero_cuenta = cast(CAST((RAND()*(10000000000-1000000000)+1000000000) AS bigint) AS VARCHAR(10))
    	WHILE EXISTS (SELECT *
    				FROM g5_cuenta_corriente
    				WHERE cc_banco = @w_numero_cuenta)
    	BEGIN
    		SELECT @w_numero_cuenta = cast(CAST((RAND()*(10000000000-1000000000)+1000000000) AS bigint) AS VARCHAR(10))
    	END 
    	INSERT INTO g5_cuenta_corriente
    		(cc_banco, cc_fecha_creacion, cc_fecha_modificacion, cc_cliente, cc_saldo)
    	VALUES 
    		(@w_numero_cuenta, getdate(),		  getdate(), @i_cliente, @i_saldo)
    END
    
   return 0
GO

