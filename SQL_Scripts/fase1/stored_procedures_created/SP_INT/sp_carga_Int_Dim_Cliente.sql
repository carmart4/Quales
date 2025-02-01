------------------------------------------------------------------------- SP FROM STG TO INTER CLIENTES - sp_carga_Int_Dim_Cliente
USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Int_Dim_Cliente]
AS
BEGIN

TRUNCATE TABLE Int_Dim_Cliente

INSERT INTO [dbo].[Int_Dim_Cliente] 
           (
			[CodigoCliente], -- [int] NOT NULL
			[RazonSocial], -- [nvarchar](100) NOT NULL
			[Telefono], -- [nvarchar](20) NOT NULL
			[Mail], -- [nvarchar](100) NOT NULL
			[Direccion], -- [nvarchar](200) NOT NULL
			[Localidad], -- [nvarchar](100) NOT NULL
			[Provincia], -- [nvarchar](200) NOT NULL
			[CP], -- [nvarchar](10) NOT NULL
			[FechaRegistro] -- [datetime] NOT NULL
			)

SELECT distinct   
	   CAST([CodigoCliente] AS int) AS CodigoCliente,
	   [RazonSocial] AS RazonSocial,
	   [Telefono] AS Telefono,
	   [Mail] AS Mail,
	   [Direccion] AS Direccion,
	   [Localidad] AS Localidad,
	   [Provincia] AS Provincia,
	   [CP] AS CP,
	   GETDATE() AS FechaRegistro
  
  FROM Stg_Dim_Cliente

END;