------------------------------------------------------------------------- SP FROM STG TO INTER VENTAS - sp_carga_Int_Fact_Ventas
USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Int_Fact_Ventas]
AS
BEGIN
SET NOCOUNT ON;

TRUNCATE TABLE Int_Fact_Ventas;

INSERT INTO [dbo].[Int_Fact_Ventas]
		(
		[CodigoVenta],
		[FechaVenta],
		[CodigoProducto],
		[Producto],
		[Cantidad],
		[PrecioVenta],
		[CodigoCliente],
		[Cliente],
		[CodigoTienda],
		[Tienda],
		[FechaRegistro]
		)

SELECT
		
        FORMAT(CAST([FechaVenta] AS date), 'yyyyMMdd') +
        'CP0' + CAST([CodigoProducto] AS nvarchar) +
        'CC0' + CAST([CodigoCliente] AS nvarchar) +
        'N' + CAST(ROW_NUMBER() OVER (
            PARTITION BY [FechaVenta], [CodigoProducto], [CodigoCliente]
            ORDER BY [FechaVenta], [CodigoProducto], [CodigoCliente]
        ) AS nvarchar) AS CodigoVenta,
        [FechaVenta],
        [CodigoProducto],
        [Producto],
        [Cantidad],
        [PrecioVenta],
        [CodigoCliente],
        [Cliente],
        [CodigoTienda],
        [Tienda],
        GETDATE()

    FROM Stg_Fact_Ventas;

END;