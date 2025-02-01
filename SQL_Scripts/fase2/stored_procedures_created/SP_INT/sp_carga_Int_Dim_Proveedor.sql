USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Int_Dim_Proveedor]
AS
BEGIN

TRUNCATE TABLE Int_Dim_Proveedor

INSERT INTO [dbo].[Int_Dim_Proveedor] 
           (
			[CodigoProveedor], -- [int] NOT NULL
			[NombreProveedor], -- [nvarchar](100) NOT NULL
			[CostoEstimado], -- [decimal](18, 2) NOT NULL
			[FechaRegistro] -- [smalldatetime] NOT NULL
			)

SELECT DISTINCT

	   CAST(CodigoProveedor AS int) AS CodigoProveedor,
	   [NombreProveedor] AS NombreProveedor,
	   CAST ([CostoEstimado] AS decimal(18, 2)) AS CostoEstimado,
	   GETDATE() AS FechaRegistro
  
  FROM Stg_Dim_Proveedor

END;