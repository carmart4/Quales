-- Crear la instancia STG
USE DW_DataShop;

-- Creacion de la tabla Stg_Dim_Provincia
DROP TABLE IF EXISTS Stg_Dim_Provincia
CREATE TABLE [dbo].[Stg_Dim_Provincia](
	[CodigoProvincia] [nvarchar](250) NOT NULL,
	[Provincia] [nvarchar](250) NOT NULL,
	[Latitud] [nvarchar](250) NOT NULL,
	[Longitud] [nvarchar](250) NOT NULL
	);

-- Creacion de la tabla Stg_Dim_Almacen
DROP TABLE IF EXISTS Stg_Dim_Almacen
CREATE TABLE [dbo].[Stg_Dim_Almacen](
	[CodigoAlmacen] [nvarchar](250) NOT NULL,
	[NombreAlmacen] [nvarchar](250) NOT NULL,
	[Ubicacion] [nvarchar](250) NOT NULL
	);

-- Creacion de la tabla Stg_Dim_Proveedor
DROP TABLE IF EXISTS Stg_Dim_Proveedor
CREATE TABLE [dbo].[Stg_Dim_Proveedor](
	[CodigoProveedor] [nvarchar](250) NOT NULL,
	[NombreProveedor] [nvarchar](250) NOT NULL,
	[CostoEstimado] [nvarchar](250) NOT NULL
	);

-- Creacion de la tabla Stg_Dim_Estado
DROP TABLE IF EXISTS Stg_Dim_Estado
CREATE TABLE [dbo].[Stg_Dim_Estado](
	[CodigoEstado] [nvarchar](250) NOT NULL,
	[Descripcion] [nvarchar](250) NOT NULL
	);

-- Creacion de la tabla Stg_Check_Entrega
DROP TABLE IF EXISTS Stg_Check_Entrega
CREATE TABLE [dbo].[Stg_Check_Entrega](
	[CodigoEntrega] [nvarchar](250) NOT NULL,
	[CodigoVenta] [nvarchar](250) NOT NULL,
	[CodigoProveedor] [nvarchar](250) NOT NULL,
	[Proveedor] [nvarchar](250) NOT NULL,
	[CodigoAlmacen] [nvarchar](250) NOT NULL,
	[Almacen] [nvarchar](250) NOT NULL,
	[CodigoEstado] [nvarchar](250) NOT NULL,
	[Estado] [nvarchar](250) NOT NULL,
	[FechaEnvio] [nvarchar](250) NOT NULL,
	[FechaEntregaEstimada] [nvarchar](250) NOT NULL
	);