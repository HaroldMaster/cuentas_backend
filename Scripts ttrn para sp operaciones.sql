SELECT TOP 10 * FROM ad_procedure ORDER BY pd_procedure desc


INSERT INTO dbo.ad_procedure (pd_procedure, pd_stored_procedure, pd_base_datos, pd_estado, pd_fecha_ult_mod, pd_archivo)
VALUES ((SELECT max(pd_procedure)+1 FROM ad_procedure), 'g5_sp_operaciones', 'cobis', 'V', GETDATE(), 'g5_transaccion')
GO

--
INSERT INTO dbo.ad_pro_transaccion (pt_producto, pt_tipo, pt_moneda, pt_transaccion, pt_estado, pt_fecha_ult_mod, pt_procedure, pt_especial)
VALUES (7, 'R', 0, 7067138, 'V', GETDATE(), 7067138, NULL)
GO


SELECT TOP 10 * FROM ad_pro_transaccion ORDER BY pt_transaccion desc

--
INSERT INTO dbo.cl_ttransaccion (tn_trn_code, tn_descripcion, tn_nemonico, tn_desc_larga)
VALUES (7067138, 'G5 Operaciones', 'CTA', 'G5 Operaciones')
GO


SELECT  * FROM cl_ttransaccion WHERE tn_trn_code IN(7067138)

--

INSERT INTO dbo.ad_tr_autorizada (ta_producto, ta_tipo, ta_moneda, ta_transaccion, ta_rol, ta_fecha_aut, ta_autorizante, ta_estado, ta_fecha_ult_mod)
VALUES (7, 'R', 0, 7067138, 3, GETDATE(), 1, 'V', GETDATE())
GO

INSERT INTO dbo.ad_tr_autorizada (ta_producto, ta_tipo, ta_moneda, ta_transaccion, ta_rol, ta_fecha_aut, ta_autorizante, ta_estado, ta_fecha_ult_mod)
VALUES (7, 'R', 0, 7067138, 7, getdate(), 1, 'V', GETDATE())
GO

SELECT * FROM ad_tr_autorizada WHERE ta_transaccion IN(70671