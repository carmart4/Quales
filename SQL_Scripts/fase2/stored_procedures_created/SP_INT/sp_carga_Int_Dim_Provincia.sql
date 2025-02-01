USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Int_Dim_Provincia]
AS
BEGIN

TRUNCATE TABLE Int_Dim_Provincia

INSERT INTO [dbo].[Int_Dim_Provincia] 
           (
			[CodigoProvincia], -- [int] NOT NULL
			[Provincia], -- [nvarchar](100) NOT NULL
			[Latitud], -- [decimal](18, 5) NOT NULL
			[Longitud], -- [decimal](18, 5) NOT NULL
			[FechaRegistro] -- [smalldatetime] NOT NULL
			)

SELECT DISTINCT   
	   CAST([CodigoProvincia] AS int) AS CodigoProvincia,
	   [Provincia] AS Provincia,
	   CAST([Latitud] AS decimal (18, 2)) AS Latitud,
	   CAST([Longitud] AS decimal (18, 2)) AS Longitud,
	   GETDATE() AS FechaRegistro
  
  FROM Stg_Dim_Provincia

END;