-- Creacion de la instancia INTERMERDIA.
USE DW_DataShop;

-- Creacion de la tabla Int_Dim_Provincia
DROP TABLE IF EXISTS Int_Dim_Provincia
CREATE TABLE [dbo].[Int_Dim_Provincia](
	[CodigoProvincia] [int] NOT NULL,
	[Provincia] [nvarchar](100) NOT NULL,
	[Latitud] [decimal](18, 5) NOT NULL,
	[Longitud] [decimal](18, 5) NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL
	);

-- Creacion de la tabla Int_Dim_Almacen
DROP TABLE IF EXISTS Int_Dim_Almacen
CREATE TABLE [dbo].[Int_Dim_Almacen](
	[CodigoAlmacen] [int] NOT NULL,
	[NombreAlmacen] [nvarchar](100) NOT NULL,
	[Ubicacion] [nvarchar](100) NOT NULL,
	--[CodigoUbicacion] [int] NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL
	);

-- Creacion de la tabla Int_Dim_Proveedor
DROP TABLE IF EXISTS Int_Dim_Proveedor
CREATE TABLE [dbo].[Int_Dim_Proveedor](
	[CodigoProveedor] [int] NOT NULL,
	[NombreProveedor] [nvarchar](100) NOT NULL,
	[CostoEstimado] [decimal](18, 2) NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL
	);

-- Creacion de la tabla Int_Dim_Estado
DROP TABLE IF EXISTS Int_Dim_Estado
CREATE TABLE [dbo].[Int_Dim_Estado](
	[CodigoEstado] [int] NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL
	);
	   
-- Creacion de la tabla Int_Check_Entrega
DROP TABLE IF EXISTS Int_Check_Entrega
CREATE TABLE [dbo].[Int_Check_Entrega](
	[CodigoEntrega] [int] NOT NULL,
	[CodigoVenta] [int] NOT NULL,
	[CodigoProveedor] [int] NOT NULL,
	[Proveedor] [nvarchar](100) NOT NULL,
	[CodigoAlmacen] [int] NOT NULL,
	[Almacen] [nvarchar](100) NOT NULL,
	[CodigoEstado] [int] NOT NULL,
	[Estado] [nvarchar](100) NOT NULL,
	[FechaEnvio] [smalldatetime] NOT NULL,
	[FechaEntregaEstimada] [smalldatetime] NOT NULL,
	[TiempoEstimado_Dias] [int] NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL
	);