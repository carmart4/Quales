USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Int_Check_Entrega]
AS
BEGIN

TRUNCATE TABLE Int_Check_Entrega;

INSERT INTO [dbo].[Int_Check_Entrega]
		(
		[CodigoEntrega], -- [int] NOT NULL
		[CodigoVenta], -- [int] NOT NULL
		[CodigoProveedor], -- [int] NOT NULL
		[Proveedor], -- [nvarchar](100) NOT NULL
		[CodigoAlmacen], -- [int] NOT NULL
		[Almacen], -- [nvarchar](100) NOT NULL
		[CodigoEstado], -- [int] NOT NULL
		[Estado], -- [nvarchar](100) NOT NULL
		[FechaEnvio], -- [smalldatetime] NOT NULL
		[FechaEntregaEstimada], -- [smalldatetime] NOT NULL
		[TiempoEstimado_Dias], -- [int] NOT NULL
		[FechaRegistro] -- [smalldatetime] NOT NULL
		)
	
SELECT DISTINCT 
		CAST([CodigoEntrega] AS int) AS CodigoEntrega,
		CAST([CodigoVenta] AS int) AS CodigoVenta,
		CAST([CodigoProveedor] AS int) AS CodigoProveedor,
		[Proveedor] AS Proveedor,
		CAST([CodigoAlmacen] AS int) AS CodigoAlmacen,
		[Almacen] AS Almacen,
		CAST([CodigoEstado] AS int) AS CodigoEstado,
		[Estado] AS Estado,
		[FechaEnvio] AS FechaEnvio,
		[FechaEntregaEstimada] AS FechaEntregaEstimada,
		DATEDIFF(DAY, [FechaEnvio], [FechaEntregaEstimada]) AS TiempoEstimado_Dias,
		GETDATE() AS FechaRegistro
	
	FROM Stg_Check_Entrega;

END;