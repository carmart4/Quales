USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Dim_Proveedor]
AS
BEGIN

	-- No truncamos la tabla para no perder la información anterior y actualizar correctamente
	-- Limpiamos los clientes que tengan valor NULL
	DELETE
	FROM Int_Dim_Proveedor
	WHERE CodigoProveedor IS NULL;

	-- Actualizamos los campos del cliente si existe
	UPDATE P

		SET 
		CodigoProveedor = I.CodigoProveedor,
		NombreProveedor = I.NombreProveedor,
		CostoEstimado = I.CostoEstimado,
		FechaActualizacion = GETDATE()

	FROM Dim_Proveedor P 
		INNER JOIN Int_Dim_Proveedor I
		ON P.CodigoProveedor=I.CodigoProveedor
	

	-- Insertamos los nuevos registros
	INSERT INTO Dim_Proveedor
	 ([CodigoProveedor],
		[NombreProveedor],
		[CostoEstimado],
		[FechaRegistro],
		[FechaActualizacion]
		)

	SELECT DISTINCT
		I.CodigoProveedor,
		I.NombreProveedor,
		I.CostoEstimado,
		GETDATE() AS FechaRegistro,
		NULL AS FechaActualizacion

	FROM Int_Dim_Proveedor I 
	LEFT JOIN Dim_Proveedor P
		ON I.CodigoProveedor=P.CodigoProveedor
		WHERE P.CodigoProveedor IS NULL;
  
 END;