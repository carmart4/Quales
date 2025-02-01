-- Creacion de la base de datos.

-- Verificamos las bases de datos que actualmente tenemos en nuestro sistema. 
-- Tambien podemos visualizar los esquemas, por si fuera necesario
-- almacenar los diferentes procedimientos en un esquema diferente. 
-- Es decir, un esquema para la instancia stg, otro int y el final dbo. 

SELECT name, database_id, create_date
FROM sys.databases;

-- Podriamos crear directamente la base de datos. Sin embargo, ejecutaremos el siguiente codigo para 
-- evitar sobre escribir, eliminando la BD que ya existe y 'empezar de cero' nuestro proyecto. 

IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'DW_DataShop') -- En caso de existir, se conecta a la BD master para eliminar la BD DataShop.
    BEGIN
		USE MASTER 
		DROP DATABASE DW_DataShop
    END

-- Creamos nuestra nueva BD. 
CREATE DATABASE DW_DataShop;

-- Creamos las tablas en nuestro esquema dbo. 

USE DW_DataShop; -- Importante para no crear las tablas en otra DB

-- Creacion de la tabla Dim_Cliente
DROP TABLE IF EXISTS Dim_Cliente;

CREATE TABLE [dbo].[Dim_Cliente](
	[IdCliente] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[CodigoCliente] [int] NOT NULL,
	[RazonSocial] [nvarchar](100) NOT NULL,
	[Telefono] [nvarchar](20) NOT NULL,
	[Mail] [nvarchar](100) NOT NULL,
	[Direccion] [nvarchar](200) NOT NULL,
	[Localidad] [nvarchar](100) NOT NULL,
	[Provincia] [nvarchar](100) NOT NULL,
	[CP] [nvarchar](10) NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL,
	[FechaActualizacion] [smalldatetime]
	);

SELECT * FROM Dim_Cliente;

-- Creacion de la tabla Dim_producto
DROP TABLE IF EXISTS Dim_Producto; 

CREATE TABLE [dbo].[Dim_Producto](
	[IdProducto] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[CodigoProducto] [int] NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
	[Categoria] [nvarchar](50) NOT NULL,
	[Marca] [nvarchar](50) NOT NULL,
	[PrecioCosto] [decimal](18, 2) NOT NULL,
	[PrecioVentaSugerido] [decimal](18, 2) NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL,
	[FechaActualizacion] [smalldatetime]
	);

SELECT * FROM Dim_Producto;

-- Creacion de la tabla Dim_Tienda
DROP TABLE IF EXISTS Dim_Tienda; 

CREATE TABLE [dbo].[Dim_Tienda](
	[IdTienda] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[CodigoTienda] [int] NOT NULL,
	[Descripcion] [nvarchar](100) NOT NULL,
	[Direccion] [nvarchar](200) NOT NULL,
	[Localidad] [nvarchar](100) NOT NULL,
	[Provincia] [nvarchar](100) NOT NULL,
	[CP] [nvarchar](10) NOT NULL,
	[TipoTienda] [nvarchar](50) NOT NULL,
	[FechaRegistro] [smalldatetime] NOT NULL,
	[FechaActualizacion] [smalldatetime]
	);

SELECT * FROM Dim_Tienda; 

-- Creacion de la tabla Fact_Ventas
DROP TABLE IF EXISTS Fact_Ventas;

CREATE TABLE [dbo].[Fact_Ventas](
	[IdVenta] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
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
)

SELECT * FROM Fact_Ventas;

-- Creacion de la tabla Dim_Tiempo
DROP TABLE IF EXISTS Dim_Tiempo;

CREATE TABLE Dim_Tiempo (
    Tiempo_Key [date] PRIMARY KEY,
    Anio [int],
    Mes [int],
    Mes_Nombre [varchar](20),
    Semestre [int],
    Trimestre [int],
    Semana_Anio [int],
    Semana_Nro_Mes [int],
    Dia [int],
    Dia_Nombre [varchar](20),
    Dia_Semana_Nro [int]
);

SELECT * FROM Dim_Tiempo;

-- Creamos las relaciones de nuestro modelo entre las diferentes tablas.
-- Es importante verificar el diagrama del modelo para las PK, FK y las diferentes
-- tablas de hechos y dimensiones. 

-- Creamos la relacion entre Fact_Ventas y Dim_tiempo. 
ALTER TABLE [dbo].[Fact_Ventas] WITH CHECK ADD FOREIGN KEY ([FechaVenta])
REFERENCES [dbo].[Dim_Tiempo] ([Tiempo_Key]);

-- Creamos la relacion entre Fact_Ventas y Dim_producto.
ALTER TABLE [dbo].[Fact_Ventas] WITH CHECK ADD FOREIGN KEY ([CodigoProducto])
REFERENCES [dbo].[Dim_Producto] ([IdProducto]);

-- Creamos la relacion entre Fact_Ventas y Dim_Cliente.
ALTER TABLE [dbo].[Fact_Ventas] WITH CHECK ADD FOREIGN KEY ([CodigoCliente])
REFERENCES [dbo].[Dim_Cliente] ([IdCliente]);

-- Creamos la relacion entre Fact_Ventas y Dim_Tienda.
ALTER TABLE [dbo].[Fact_Ventas] WITH CHECK ADD FOREIGN KEY ([CodigoTienda])
REFERENCES [dbo].[Dim_Tienda] ([IdTienda]);