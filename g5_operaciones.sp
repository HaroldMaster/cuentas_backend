USE cobis
go
IF OBJECT_ID ('dbo.g5_sp_operaciones') IS NOT NULL
	DROP PROCEDURE dbo.g5_sp_operaciones
GO

CREATE proc g5_sp_operaciones(
   @s_srv           varchar(30) = NULL,
   @s_ssn           int         = NULL,
   @s_ssn_branch    int         = 0,
   @s_date          datetime    = NULL,
   @s_ofi           smallint    = NULL,
   @t_debug         char(1)     = 'N', 
   @s_user          varchar(30) = NULL,
   @s_lsrv          varchar(30) = NULL,
   @s_rol           smallint    = 1,
   @s_term          varchar(10) = NULL,
   @s_org           char(1)     = NULL,
   @s_culture       varchar(10) = 'NEUTRAL',
   @t_file          varchar(14) = NULL,
   @i_operacion     char(1),
   @t_trn            INT =99,
   @i_cuentaOrigen	VARCHAR(30),
   @i_cuentaDe		VARCHAR(30) = NULL,
   @i_tipoCuentaOr	VARCHAR(30) = NULL,
   @i_tipoCuentaDe	VARCHAR(30) = NULL,
   @i_valor			float
   )
as
   declare @w_sp_name       varchar(18),
           @w_return              int
   select @w_sp_name = 'g5_sp_operaciones'
   
    
    if @i_operacion='C'
    BEGIN
    	IF @i_tipoCuentaOr = 'A'
    	BEGIN
			UPDATE g5_cuenta_ahorros
			SET 
			ca_saldo = ca_saldo + @i_valor
			WHERE
			ca_banco = @i_cuentaOrigen
			if @@error != 0
		    begin
		         select @w_return = 103015
		         GOTO ERROR
		    END
    	END
    	
    	IF @i_tipoCuentaOr = 'C'
    	BEGIN
			UPDATE g5_cuenta_corriente
			SET 
			cc_saldo = cc_saldo + @i_valor
			WHERE
			cc_banco = @i_cuentaOrigen
			if @@error != 0
		    begin
		         select @w_return = 103015
		         GOTO ERROR
		    END
			    	
    	END
    	-- Transaccion
    	INSERT INTO g5_transaccion
		    (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
		VALUES
		    (@s_ssn,getdate(),	@i_cuentaOrigen,'D',		@i_tipoCuentaOr)
		    if @@error != 0
		      begin
		         select @w_return = 103005
		         GOTO ERROR
		      end
    END
    
    if @i_operacion='R'
    BEGIN
    	IF @i_tipoCuentaOr = 'A'
    	BEGIN
			UPDATE g5_cuenta_ahorros
			SET 
			ca_saldo = ca_saldo - @i_valor
			WHERE
			ca_banco = @i_cuentaOrigen
			if @@error != 0
		    begin
		         select @w_return = 103015
		         GOTO ERROR
		    END	
    	END
    	
    	IF @i_tipoCuentaOr = 'C'
    	BEGIN
			UPDATE g5_cuenta_corriente
			SET 
			cc_saldo = cc_saldo - @i_valor
			WHERE
			cc_banco = @i_cuentaOrigen     
			if @@error != 0
		    begin
		         select @w_return = 103015
		         GOTO ERROR
		    END	
    	END
    	-- Transaccion
    	INSERT INTO g5_transaccion
		    (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
		VALUES
		    (@s_ssn,getdate(),	@i_cuentaOrigen,'R',		@i_tipoCuentaOr)
	    if @@error != 0
	      begin
	         select @w_return = 103005
	         GOTO ERROR
	      end
    END
    
    if @i_operacion='T'
    BEGIN
    	IF @i_tipoCuentaOr = 'A'
    	BEGIN
			UPDATE g5_cuenta_ahorros
			SET 
			ca_saldo = ca_saldo - @i_valor
			WHERE
			ca_banco = @i_cuentaOrigen
			
			IF @i_tipoCuentaDe = 'A'
			BEGIN
				UPDATE g5_cuenta_ahorros
				SET 
				ca_saldo = ca_saldo + @i_valor
				WHERE
				ca_banco = @i_cuentaDe
			END
			
			IF @i_tipoCuentaDe = 'C'
			BEGIN
				UPDATE g5_cuenta_corriente
				SET 
				cc_saldo = cc_saldo + @i_valor
				WHERE
				cc_banco = @i_cuentaDe
			END	    	
    	END
    	
    	IF @i_tipoCuentaOr = 'C'
    	BEGIN
			UPDATE g5_cuenta_corriente
			SET 
			cc_saldo = cc_saldo - @i_valor
			WHERE
			cc_banco = @i_cuentaOrigen
			
			IF @i_tipoCuentaDe = 'A'
			BEGIN
				UPDATE g5_cuenta_ahorros
				SET 
				ca_saldo = ca_saldo + @i_valor
				WHERE
				ca_banco = @i_cuentaDe
			END
			
			IF @i_tipoCuentaDe = 'C'
			BEGIN
				UPDATE g5_cuenta_corriente
				SET 
				cc_saldo = cc_saldo + @i_valor
				WHERE
				cc_banco = @i_cuentaDe
			END	    	
    	END
    	-- Transaccion
    	INSERT INTO g5_transaccion
		    (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
		VALUES
		    (@s_ssn,getdate(),	@i_cuentaOrigen,'R',		@i_tipoCuentaOr)
	    if @@error != 0
	      begin
	         select @w_return = 103005
	         GOTO ERROR
	      END
	    -- Transaccion
    	INSERT INTO g5_transaccion
		    (tr_id,	tr_fecha,	tr_cuenta,		tr_tipo_tr,	tr_tipo_cuenta)
		VALUES
		    (@s_ssn,getdate(),	@i_cuentaOrigen,'D',		@i_tipoCuentaDe)
	    if @@error != 0
	      begin
	         select @w_return = 103005
	         GOTO ERROR
	      end
    END
   return 0
   
ERROR:
   exec sp_cerror 
       @t_debug = @t_debug,
       @t_file  = @t_file,
       @t_from  = @w_sp_name,
       @i_num   = @w_return 
   return @w_return

GO

