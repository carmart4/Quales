USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Dim_Estado]
AS
BEGIN

	-- No truncamos la tabla para no perder la información anterior y actualizar correctamente
	-- Limpiamos los clientes que tengan valor NULL
	DELETE
	FROM Int_Dim_Estado
	WHERE CodigoEstado IS NULL;

	-- Actualizamos los campos del cliente si existe
	UPDATE E

		SET 
		CodigoEstado = I.CodigoEstado,
		Descripcion = I.Descripcion,
		FechaActualizacion = GETDATE()

	FROM Dim_Estado E
		INNER JOIN Int_Dim_Estado I
		ON E.CodigoEstado=I.CodigoEstado;

	-- Insertamos los nuevos registros
	INSERT INTO Dim_Estado
	 ([CodigoEstado],
		[Descripcion],
		[FechaRegistro],
		[FechaActualizacion]
		)

	SELECT DISTINCT
		I.CodigoEstado,
		I.Descripcion,
		GETDATE() AS FechaRegistro,
		NULL AS FechaActualizacion
		
	FROM Int_Dim_Estado I 
		LEFT JOIN Dim_Estado E
			ON I.CodigoEstado=E.CodigoEstado
	WHERE E.CodigoEstado IS NULL;
  
 END;