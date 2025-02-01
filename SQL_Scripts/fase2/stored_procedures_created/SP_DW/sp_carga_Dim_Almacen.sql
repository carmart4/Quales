USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Dim_Almacen]
AS
BEGIN

	-- No truncamos la tabla para no perder la información anterior y actualizar correctamente
	-- Limpiamos los clientes que tengan valor NULL
	DELETE
	FROM Int_Dim_Almacen
	WHERE CodigoAlmacen IS NULL;

	-- Actualizamos los campos del cliente si existe
	UPDATE A

		SET 
		CodigoAlmacen = I.CodigoAlmacen,
		NombreAlmacen = I.NombreAlmacen,
		Ubicacion = I.Ubicacion,
		CodigoUbicacion = P.IdProvincia,
		FechaActualizacion = GETDATE()

	FROM Dim_Almacen A 
		INNER JOIN Int_Dim_Almacen I
		ON A.CodigoAlmacen=I.CodigoAlmacen
	LEFT JOIN Dim_Provincia P
		ON I.Ubicacion = P.Provincia;

	-- Insertamos los nuevos registros
	INSERT INTO Dim_Almacen
	 ([CodigoAlmacen],
		[NombreAlmacen],
		[Ubicacion],
		[CodigoUbicacion],
		[FechaRegistro],
		[FechaActualizacion]
		)

	SELECT DISTINCT
		I.CodigoAlmacen,
		I.NombreAlmacen,
		I.Ubicacion,
		P.IdProvincia,
		GETDATE() AS FechaRegistro,
		NULL AS FechaActualizacion
		
	FROM Int_Dim_Almacen I
	LEFT JOIN Dim_Provincia P
		ON I.Ubicacion = P.Provincia
	full outer JOIN Dim_Almacen A
		ON I.CodigoAlmacen = A.CodigoAlmacen
	WHERE A.CodigoAlmacen IS NULL;
  
 END;