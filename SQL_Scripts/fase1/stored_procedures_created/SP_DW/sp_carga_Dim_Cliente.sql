------------------------------------------------------------------------- SP FROM INTER TO DIM CLIENTES - sp_carga_Dim_Cliente
USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Dim_Cliente]
AS
BEGIN

	-- No truncamos la tabla para no perder la información anterior y actualizar correctamente
	-- Limpiamos los clientes que tengan valor NULL
	DELETE
	FROM Int_Dim_Cliente
	WHERE CodigoCliente IS NULL;

	-- Actualizamos los campos del cliente si existe
	UPDATE C

		SET CodigoCliente=D.CodigoCliente,
		RazonSocial=D.RazonSocial,
		Telefono=D.Telefono,
		Mail=D.Mail,
		Direccion=D.Direccion,
		Localidad=D.Localidad,
		Provincia=D.Provincia,
		CP=D.CP,
		FechaActualizacion = GETDATE()

	FROM Dim_Cliente C 
		INNER JOIN Int_Dim_Cliente D
		ON C.CodigoCliente=D.CodigoCliente;

	-- Insertamos los nuevos registros
	INSERT INTO Dim_Cliente
	 ([CodigoCliente],
		[RazonSocial],
		[Telefono],
		[Mail],
		[Direccion], 
		[Localidad],
		[Provincia],
		[CP],
		[FechaRegistro],
		[FechaActualizacion])

	SELECT DISTINCT
		I.CodigoCliente,
		I.RazonSocial,
		I.Telefono,
		I.Mail,
		I.Direccion,
		I.Localidad,
		I.Provincia,
		I.CP,
		GETDATE() AS FechaRegistro,
		NULL AS FechaActualizacion
		
	FROM Int_Dim_Cliente I 
		LEFT JOIN Dim_Cliente D
			ON I.CodigoCliente=D.CodigoCliente
	WHERE D.CodigoCliente IS NULL;
  
 END;