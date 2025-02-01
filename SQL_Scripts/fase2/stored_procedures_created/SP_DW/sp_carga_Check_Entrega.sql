USE DW_DataShop;

-- Vamos a calcular tiempo entrega real en días 
-- Haremos uso de lafórmula del Haversine para calcular la distancia 
-- entre dos puntos (latitud y longitud) en una esfera.
-- El promedio de millas en EEUU, para empresas de envíos, 
-- esta entre 400 a 500 por día. Considerando esto y la conversión a km, 
-- obtenemos una aproximación del 'tiempo real' en días. 

GO
CREATE PROCEDURE [dbo].[SP_Carga_Check_Entrega]
AS
BEGIN

	-- No truncamos la tabla para no perder la información anterior y actualizar correctamente
	-- Limpiamos los clientes que tengan valor NULL
	DELETE 
	FROM Int_Check_Entrega
	WHERE CodigoVenta NOT IN (SELECT IdVenta FROM Fact_Ventas);


	-- Actualizamos los campos del cliente si existe
	UPDATE ce

		SET 
		CodigoEntrega = I.CodigoEntrega,
		CodigoVenta = I.CodigoVenta,
		CodigoProveedor = I.CodigoProveedor,
		Proveedor = I.Proveedor,
		CodigoAlmacen = I.CodigoAlmacen,
		Almacen = I.Almacen,
		CodigoEstado = I.CodigoEstado,
		Estado = I.Estado,
		FechaEnvio = I.FechaEnvio,
		FechaEntregaEstimada = I.FechaEntregaEstimada,
		TiempoEstimado_Dias = I.TiempoEstimado_Dias,
		TiempoReal = ISNULL(CAST(((6371 * ACOS(
						COS(RADIANS(p.Latitud)) * COS(RADIANS(p2.Latitud)) *
						COS(RADIANS(p2.Longitud) - RADIANS(p.Longitud)) +
						SIN(RADIANS(p.Latitud)) * SIN(RADIANS(p2.Latitud))))/804) AS int), 9999), -- 9999 para reconocer el nulo.
		FechaRegistro = I.FechaRegistro,
		UbicacionAlmacen = a.Ubicacion,
		UbicacionCliente = c.Provincia,
		DistanciaKM = ISNULL(CAST(((6371 * ACOS(
						COS(RADIANS(p.Latitud)) * COS(RADIANS(p2.Latitud)) *
						COS(RADIANS(p2.Longitud) - RADIANS(p.Longitud)) +
						SIN(RADIANS(p.Latitud)) * SIN(RADIANS(p2.Latitud))))/804) AS decimal(18,5)), 9999),
		CostoEstimado = pr.CostoEstimado

	FROM Check_Entrega ce 
		INNER JOIN Int_Check_Entrega I
		ON ce.CodigoEntrega=I.CodigoEntrega
		--FROM Int_Check_Entrega I
		LEFT JOIN Dim_Proveedor pr
			ON I.CodigoProveedor = pr.IdProveedor
		LEFT JOIN Fact_Ventas v
			ON I.CodigoVenta = v.IdVenta
		LEFT JOIN Dim_Almacen a
			ON I.CodigoAlmacen = a.IdAlmacen
		LEFT JOIN Dim_Cliente c
			ON c.CodigoCliente = v.CodigoCliente
		LEFT JOIN Dim_Provincia p
			ON p.Provincia = a.Ubicacion
		LEFT JOIN Dim_Provincia p2
			ON p2.Provincia = c.Provincia
		WHERE v.IdVenta IS NOT NULL AND c.Localidad != 'NaL';

	INSERT INTO [dbo].[Check_Entrega]
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
		[TiempoReal], -- [int] NOT NULL
		[FechaRegistro], -- [smalldatetime] NOT NULL
		[UbicacionAlmacen], -- [nvarchar](100) NOT NULL
		[UbicacionCliente], -- [nvarchar](100) NOT NULL
		[DistanciaKM], -- [decimal](18, 2) NOT NULL
		[CostoEstimado] --[decimal](18, 2) NOT NULL
		)

	SELECT DISTINCT 
		I.CodigoEntrega, --AS CodigoEntrega,
		I.CodigoVenta, --AS CodigoVenta,
		I.CodigoProveedor, --AS CodigoProveedor,
		I.Proveedor, --AS Proveedor,
		I.CodigoAlmacen, --AS CodigoAlmacen,
		I.Almacen, --AS Almacen,
		I.CodigoEstado, --AS CodigoEstado,
		I.Estado, --AS Estado,
		I.FechaEnvio, --AS FechaEnvio,
		I.FechaEntregaEstimada, --AS FechaEntregaEstimada,
		I.TiempoEstimado_Dias, --AS TiempoEstimado_Dias,
		ISNULL(CAST(((6371 * ACOS(
				COS(RADIANS(p.Latitud)) * COS(RADIANS(p2.Latitud)) *
				COS(RADIANS(p2.Longitud) - RADIANS(p.Longitud)) +
				SIN(RADIANS(p.Latitud)) * SIN(RADIANS(p2.Latitud))))/804) AS int),9999) AS TiempoReal,
		GETDATE() AS FechaRegistro,
		a.Ubicacion,
		c.Provincia,
		ISNULL(CAST(((6371 * ACOS(
				COS(RADIANS(p.Latitud)) * COS(RADIANS(p2.Latitud)) *
				COS(RADIANS(p2.Longitud) - RADIANS(p.Longitud)) +
				SIN(RADIANS(p.Latitud)) * SIN(RADIANS(p2.Latitud))))/804) AS decimal (18,5)), 9999),
		pr.CostoEstimado
	
	FROM Int_Check_Entrega I 
		LEFT JOIN Check_Entrega ce
		ON I.CodigoEntrega=ce.CodigoEntrega
		LEFT JOIN Dim_Proveedor pr
		ON I.CodigoProveedor = pr.IdProveedor
		LEFT JOIN Fact_Ventas v
		ON I.CodigoVenta = v.IdVenta
		LEFT JOIN Dim_Almacen a
		ON I.CodigoAlmacen = a.IdAlmacen
		LEFT JOIN Dim_Cliente c
		ON c.CodigoCliente = v.CodigoCliente
		LEFT JOIN Dim_Provincia p
		ON p.Provincia = a.Ubicacion
		LEFT JOIN Dim_Provincia p2
		ON p2.Provincia = c.Provincia
		WHERE ce.CodigoEntrega IS NULL

	DELETE
	FROM Check_Entrega
	WHERE DistanciaKM = 9999 OR TiempoReal = 9999 OR UbicacionCliente='NaP';

END;