------------------------------------------------------------------------- SP FROM INTER TO DIM TIENDAS - sp_carga_Dim_Tienda
USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Dim_Tienda]
AS
BEGIN
	-- No truncamos la tabla para no perder la información anterior y actualizar correctamente
	-- Limpiamos las tiendas que tengan valor NULL
	DELETE
	FROM Int_Dim_Tienda
	WHERE CodigoTienda IS NULL;

	-- Actualizamos los campos de la tienda si existe
	UPDATE T

		SET CodigoTienda=D.CodigoTienda,
		Descripcion=D.Descripcion,
		Direccion=D.Direccion,
		Localidad=D.Localidad,
		Provincia=D.Provincia,
		CP=D.CP,
		TipoTienda=D.TipoTienda,
		FechaActualizacion = GETDATE()

	FROM Dim_Tienda T 
		INNER JOIN Int_Dim_Tienda D
		ON T.CodigoTienda=D.CodigoTienda;

	-- Insertamos los nuevos registros
	INSERT INTO Dim_Tienda
	 ([CodigoTienda],
		[Descripcion],
		[Direccion], 
		[Localidad],
		[Provincia],
		[CP],
		[TipoTienda],
		[FechaRegistro],
		[FechaActualizacion])

	SELECT DISTINCT 
		I.CodigoTienda,
		I.Descripcion,
		I.Direccion,
		I.Localidad,
		I.Provincia,
		I.CP,
		I.TipoTienda,
		GETDATE() AS FechaRegistro,
		NULL AS FechaActualizacion
		
	FROM Int_Dim_Tienda I 
		LEFT JOIN Dim_Tienda D
			ON I.CodigoTienda=D.CodigoTienda
	WHERE D.CodigoTienda IS NULL;
  
 END;