------------------------------------------------------------------------- SP FROM STG TO INTER TIENDAS - sp_carga_Int_Dim_Tienda
USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Int_Dim_Tienda] 
AS
BEGIN

TRUNCATE TABLE Int_Dim_Tienda

INSERT INTO [dbo].[Int_Dim_Tienda] 
           (
			[CodigoTienda], -- [int] NOT NULL
			[Descripcion], -- [nvarchar](100) NOT NULL
			[Direccion], -- [nvarchar](200) NOT NULL
			[Localidad], -- [nvarchar](100) NOT NULL
			[Provincia], -- [nvarchar](100) NOT NULL
			[CP], -- [nvarchar](10) NOT NULL
			[TipoTienda], -- [nvarchar](200) NOT NULL
			[FechaRegistro] -- [datetime] NOT NULL
			)
		    
SELECT distinct   
	   CAST([CodigoTienda] AS int) AS [CodigoTienda],
	   [Descripcion] AS Descripcion,
	   [Direccion] AS Direccion,
	   [Localidad] AS Localidad,
	   [Provincia] AS Provincia,
	   [CP] AS CP,
	   [TipoTienda] AS TipoTienda,
	   GETDATE() AS FechaRegistro
  
  FROM Stg_Dim_Tienda

END;