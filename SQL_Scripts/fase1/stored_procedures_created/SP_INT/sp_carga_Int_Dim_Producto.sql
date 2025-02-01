------------------------------------------------------------------------- SP FROM STG TO INTER PRODUCTOS - sp_carga_Int_Dim_Producto
USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Int_Dim_Producto] 
AS
BEGIN

TRUNCATE TABLE Int_Dim_Producto -- Truncamos la tabla para cargar la información

INSERT INTO [dbo].[Int_Dim_Producto] -- Importante tener la referencia del tipo de dato al que queremos castear nuestros valores 
           (
			[CodigoProducto], -- [int] NOT NULL
			[Descripcion], -- [varchar](100) NOT NULL
			[Categoria], -- [varchar](50) NOT NULL
			[Marca], -- [varchar](50) NOT NULL
			[PrecioCosto], -- [decimal](18, 2) NOT NULL
			[PrecioVentaSugerido], -- [decimal](18, 2) NOT NULL
			[FechaRegistro] -- [datetime] NOT NULL 
			)
		    
SELECT distinct   
	   CAST([CodigoProducto] AS int) AS CodigoProducto
      ,[Descripcion] as Descripcion
      ,[Categoria] as Categoria
	  ,[Marca] as Marca
      ,CAST([PrecioCosto] AS decimal (18, 2)) AS PrecioCosto
      ,CAST([PrecioVentaSugerido]  AS decimal (18, 2)) AS PrecioVentaSugerido
	  ,GETDATE() AS FechaRegistro

  FROM Stg_Dim_Producto

END;