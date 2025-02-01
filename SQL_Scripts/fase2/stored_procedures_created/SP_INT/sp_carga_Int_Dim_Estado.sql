USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Int_Dim_Estado]
AS
BEGIN

TRUNCATE TABLE Int_Dim_Estado

INSERT INTO [dbo].[Int_Dim_Estado] 
           (
			[CodigoEstado], -- [int] NOT NULL
			[Descripcion], -- [nvarchar](100) NOT NULL
			[FechaRegistro] -- [smalldatetime] NOT NULL
			)

SELECT DISTINCT   
	   CAST(CodigoEstado AS int) AS CodigoEstado,
	   [Descripcion] AS Descripcion,
	   GETDATE() AS FechaRegistro
  
  FROM Stg_Dim_Estado

END;