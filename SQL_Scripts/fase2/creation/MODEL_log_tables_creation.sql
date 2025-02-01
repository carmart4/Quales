-- Seguimos trabajando en nuestra base DW_DataShop

USE DW_DataShop; -- Importante para no crear las tablas en otra DB

-- Creacion de la tabla Dim_Provincia -- Es el primero para cargar adecuadamente Dim_Almacen
DROP TABLE IF EXISTS Dim_Provincia; 

CREATE TABLE [dbo].[Dim_Provincia](
	[IdProvincia] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[CodigoProvincia] [int] NOT NULL,
	[Provincia] [nvarchar](100) NOT NULL,
	[Latitud] [decimal](18, 5) NOT NULL,
	[Longitud] [decimal](18, 5) NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL,
	[FechaActualizacion] [smalldatetime]
	);

SELECT * FROM Dim_Provincia;

-- Creacion de la tabla Dim_Almacen
DROP TABLE IF EXISTS Dim_Almacen;

CREATE TABLE [dbo].[Dim_Almacen](
	[IdAlmacen] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[CodigoAlmacen] [int] NOT NULL,
	[NombreAlmacen] [nvarchar](100) NOT NULL,
	[Ubicacion] [nvarchar](100) NOT NULL,
	[CodigoUbicacion] [int] NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL,
	[FechaActualizacion] [smalldatetime]
	);

SELECT * FROM Dim_Almacen;

-- Creacion de la tabla Dim_Proveedor
DROP TABLE IF EXISTS Dim_Proveedor; 

CREATE TABLE [dbo].[Dim_Proveedor](
	[IdProveedor] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[CodigoProveedor] [int] NOT NULL,
	[NombreProveedor] [nvarchar](100) NOT NULL,
	[CostoEstimado] [decimal](18, 2) NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL,
	[FechaActualizacion] [smalldatetime]
	);
	
SELECT * FROM Dim_Proveedor;

-- Creacion de la tabla Dim_Estado
DROP TABLE IF EXISTS Dim_Estado; 

CREATE TABLE [dbo].[Dim_Estado](
	[IdEstado] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[CodigoEstado] [int] NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL,
	[FechaActualizacion] [smalldatetime]
	);

SELECT * FROM Dim_Estado;

-- Creacion de la tabla Check_Entrega
DROP TABLE IF EXISTS Check_Entrega;

CREATE TABLE [dbo].[Check_Entrega](
	[IdEntrega] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
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
	[TiempoReal] [int] NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL,
	[UbicacionAlmacen] [nvarchar](100) NOT NULL,
	[UbicacionCliente] [nvarchar](100) NOT NULL,
	[DistanciaKM] [decimal](18, 2) NOT NULL,
	[CostoEstimado] [decimal](18, 2) NOT NULL
	);

SELECT * FROM Check_Entrega;

-- Creamos las relaciones de nuestro modelo entre las diferentes tablas.
-- Es importante verificar el diagrama del modelo para las PK, FK y las diferentes
-- tablas de hechos y dimensiones. 

-- Creamos la relacion entre Check_Entrega y Dim_Proveedor. 
ALTER TABLE [dbo].[Check_Entrega] WITH CHECK ADD FOREIGN KEY ([CodigoProveedor])
REFERENCES [dbo].[Dim_Proveedor] ([IdProveedor]);

-- Creamos la relacion entre Check_Entrega y Dim_Estado.
ALTER TABLE [dbo].[Check_Entrega] WITH CHECK ADD FOREIGN KEY ([CodigoEstado])
REFERENCES [dbo].[Dim_Estado] ([IdEstado]);

-- Creamos la relacion entre Check_Entrega y Dim_Almacen.
ALTER TABLE [dbo].[Check_Entrega] WITH CHECK ADD FOREIGN KEY ([CodigoAlmacen])
REFERENCES [dbo].[Dim_Almacen] ([IdAlmacen]);

-- Creamos la relacion entre Check_Entrega y Fact_Ventas.
ALTER TABLE [dbo].[Check_Entrega] WITH CHECK ADD FOREIGN KEY ([CodigoVenta])
REFERENCES [dbo].[Fact_Ventas] ([IdVenta]);

-- Creamos la relacion entre Dim_Almacen y Dim_Provincia.
ALTER TABLE [dbo].[Dim_Almacen] WITH CHECK ADD FOREIGN KEY ([CodigoUbicacion])
REFERENCES [dbo].[Dim_Provincia] ([IdProvincia]);