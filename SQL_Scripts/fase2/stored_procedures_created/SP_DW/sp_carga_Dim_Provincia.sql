USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Dim_Provincia]
AS
BEGIN

	-- No truncamos la tabla para no perder la información anterior y actualizar correctamente
	-- Limpiamos los clientes que tengan valor NULL
	DELETE
	FROM Int_Dim_Provincia
	WHERE CodigoProvincia IS NULL;

	-- Actualizamos los campos del cliente si existe
	UPDATE P

		SET 
		CodigoProvincia = I.CodigoProvincia,
		Provincia = I.Provincia,
		Latitud = I.Latitud,
		Longitud = I.Longitud,
		FechaActualizacion = GETDATE()

	FROM Dim_Provincia P 
		INNER JOIN Int_Dim_Provincia I
		ON P.CodigoProvincia=I.CodigoProvincia;

	-- Insertamos los nuevos registros
	INSERT INTO Dim_Provincia
	 ([CodigoProvincia],
		[Provincia],
		[Latitud],
		[Longitud],
		[FechaRegistro],
		[FechaActualizacion]
		)

	SELECT DISTINCT
		I.CodigoProvincia,
		I.Provincia,
		I.Latitud,
		I.Longitud,
		GETDATE() AS FechaRegistro,
		NULL AS FechaActualizacion
		
	FROM Int_Dim_Provincia I 
		LEFT JOIN Dim_Provincia P
			ON I.CodigoProvincia=P.CodigoProvincia
	WHERE P.CodigoProvincia IS NULL;
  
 END;