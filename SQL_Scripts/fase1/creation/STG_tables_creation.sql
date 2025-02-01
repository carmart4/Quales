-- Crear la instancia STG
USE DW_DataShop;

-- Creacion de la tabla Stg_Dim_Cliente
CREATE TABLE [dbo].[Stg_Dim_Cliente](
	[CodigoCliente] [nvarchar](250) NOT NULL,
	[RazonSocial] [nvarchar](250) NOT NULL,
	[Telefono] [nvarchar](250) NOT NULL,
	[Mail] [nvarchar](250) NOT NULL,
	[Direccion] [nvarchar](250) NOT NULL,
	[Localidad] [nvarchar](250) NOT NULL,
	[Provincia] [nvarchar](250) NOT NULL,
	[CP] [nvarchar](250) NOT NULL
	);

-- Creacion de la tabla Stg_Dim_Producto
CREATE TABLE [dbo].[Stg_Dim_Producto](
	[CodigoProducto] [nvarchar](250) NOT NULL,
	[Descripcion] [nvarchar](250) NOT NULL,
	[Categoria] [nvarchar](250) NOT NULL,
	[Marca] [nvarchar](250) NOT NULL,
	[PrecioCosto] [nvarchar](250) NOT NULL,
	[PrecioVentaSugerido] [nvarchar](250) NOT NULL
	);

-- Creacion de la tabla Stg_Dim_Tienda
CREATE TABLE [dbo].[Stg_Dim_Tienda](
	[CodigoTienda] [nvarchar](250) NOT NULL,
	[Descripcion] [nvarchar](250) NOT NULL,
	[Direccion] [nvarchar](250) NOT NULL,
	[Localidad] [nvarchar](250) NOT NULL,
	[Provincia] [nvarchar](250) NOT NULL,
	[CP] [nvarchar](250) NOT NULL,
	[TipoTienda] [nvarchar](250) NOT NULL,
	);

-- Creacion de la tabla Stg_Fact_Ventas
CREATE TABLE [dbo].[Stg_Fact_Ventas](
	[FechaVenta] [nvarchar](250) NOT NULL,
	[CodigoProducto] [nvarchar](250) NOT NULL,
	[Producto] [nvarchar](250) NOT NULL,
	[Cantidad] [nvarchar](250) NOT NULL,
	[PrecioVenta] [nvarchar](250) NOT NULL,
	[CodigoCliente] [nvarchar](250) NOT NULL,
	[Cliente] [nvarchar](250) NOT NULL,
	[CodigoTienda] [nvarchar](250) NOT NULL,
	[Tienda] [nvarchar](250) NOT NULL
); 

-- Visualizamos las tablas que creamos para la instancia STG
SELECT * FROM Stg_Dim_Cliente
SELECT * FROM Stg_Dim_Producto
SELECT * FROM Stg_Dim_Tienda
SELECT * FROM Stg_Fact_Ventas