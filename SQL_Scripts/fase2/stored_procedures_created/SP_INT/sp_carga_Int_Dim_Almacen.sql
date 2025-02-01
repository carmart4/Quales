USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Int_Dim_Almacen]
AS
BEGIN

TRUNCATE TABLE Int_Dim_Almacen

INSERT INTO [dbo].[Int_Dim_Almacen] 
           (
			[CodigoAlmacen], -- [int] NOT NULL
			[NombreAlmacen], -- [nvarchar](100) NOT NULL
			[Ubicacion], -- [nvarchar](100) NOT NULL
			[FechaRegistro] -- [smalldatetime] NOT NULL
			)

SELECT DISTINCT   
	   CAST(CodigoAlmacen AS int) AS CodigoAlmacen,
	   [NombreAlmacen] AS NombreAlmacen,
	   [Ubicacion] AS Ubicacion,
	   GETDATE() AS FechaRegistro
  
  FROM Stg_Dim_Almacen

END;