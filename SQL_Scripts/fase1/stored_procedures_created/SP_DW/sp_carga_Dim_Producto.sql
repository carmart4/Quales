------------------------------------------------------------------------- SP FROM INTER TO DIM PRODUCTOS - sp_carga_Dim_Producto
USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Dim_Producto]
AS
BEGIN
	-- No truncamos la tabla para no perder la información anterior y actualizar correctamente
	-- Limpiamos los productos que tengan valor NULL
	DELETE
	FROM Int_Dim_Producto
	WHERE CodigoProducto IS NULL;

	-- Actualizamos los campos del producto si existe
	UPDATE C

		SET CodigoProducto=D.CodigoProducto,
		Descripcion=D.Descripcion,
		Categoria=D.Categoria, 
		Marca=D.Marca,
		PrecioCosto=D.PrecioCosto,
		PrecioVentaSugerido=D.PrecioVentaSugerido,
		FechaActualizacion = GETDATE()

	FROM Dim_Producto C 
		INNER JOIN Int_Dim_Producto D
		ON C.CodigoProducto=D.CodigoProducto;

	-- Insertamos los nuevos registros
	INSERT INTO Dim_Producto
	 ([CodigoProducto],
		[Descripcion],
		[Categoria], 
		[Marca],
		[PrecioCosto],
		[PrecioVentaSugerido],
		[FechaRegistro],
		[FechaActualizacion])

	SELECT DISTINCT
		I.CodigoProducto,
		I.Descripcion,
		I.Categoria,
		I.Marca,
		I.PrecioCosto,
		I.PrecioVentaSugerido,
		GETDATE() AS FechaRegistro,
		NULL AS FechaActualizacion
		
	FROM Int_Dim_Producto I 
		LEFT JOIN Dim_Producto D
			ON I.CodigoProducto=D.CodigoProducto
	WHERE D.CodigoProducto IS NULL;
  
 END;