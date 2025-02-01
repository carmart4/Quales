-- Creacion de la instancia INTERMERDIA.
USE DW_DataShop;

-- Creacion de la tabla Int_Dim_Cliente
CREATE TABLE [dbo].[Int_Dim_Cliente](
	[CodigoCliente] [int] NOT NULL,
	[RazonSocial] [nvarchar](100) NOT NULL,
	[Telefono] [nvarchar](20) NOT NULL,
	[Mail] [nvarchar](100) NOT NULL,
	[Direccion] [nvarchar](200) NOT NULL,
	[Localidad] [nvarchar](100) NOT NULL,
	[Provincia] [nvarchar](100) NOT NULL,
	[CP] [nvarchar](10) NOT NULL,
	[FechaRegistro] [datetime] NOT NULL
	);

-- Creacion de la tabla Int_Dim_Producto
CREATE TABLE [dbo].[Int_Dim_Producto](
	[CodigoProducto] [int] NOT NULL,
	[Descripcion] [nvarchar] (100) NOT NULL,
	[Categoria] [nvarchar] (50) NOT NULL,
	[Marca] [nvarchar] (50) NOT NULL,
	[PrecioCosto] [decimal] (18, 2) NOT NULL,
	[PrecioVentaSugerido] [decimal] (18, 2) NOT NULL,
	[FechaRegistro] [datetime] NOT NULL
	);

-- Creacion de la tabla Int_Dim_Tienda
CREATE TABLE [dbo].[Int_Dim_Tienda](
	[CodigoTienda] [int] NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
	[Direccion] [nvarchar](200) NOT NULL,
	[Localidad] [nvarchar](100) NOT NULL,
	[Provincia] [nvarchar](100) NOT NULL,
	[CP] [nvarchar](10) NOT NULL,
	[TipoTienda] [nvarchar](200) NOT NULL,
	[FechaRegistro] [datetime] NOT NULL
	);
	   
-- Creacion de la tabla Int_Fact_Ventas
CREATE TABLE [dbo].[Int_Fact_Ventas](
	[CodigoVenta] [varchar](40) NOT NULL,
	[FechaVenta] [date] NOT NULL,
	[CodigoProducto] [int] NOT NULL,
	[Producto] [nvarchar](110) NOT NULL,
	[Cantidad] [int] NOT NULL,
	[PrecioVenta] [decimal](18,2) NOT NULL,
	[CodigoCliente] [int] NOT NULL,
	[Cliente] [nvarchar](110) NOT NULL,
	[CodigoTienda] [int] NOT NULL,
	[Tienda] [nvarchar](110) NOT NULL, 
	[FechaRegistro] [smalldatetime] NOT NULL
	);

-- Visualizamos las tablas que creamos para nuestra instancia INTER.
SELECT * FROM Int_Dim_Cliente
SELECT * FROM Int_Dim_Producto
SELECT * FROM Int_Dim_Tienda
SELECT * FROM Int_Fact_Ventas