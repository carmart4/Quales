------------------------------------------------------------------------- SP FROM INTER TO FAC VENTAS - sp_carga_Fact_Ventas
USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[SP_Carga_Fact_Ventas]
AS
BEGIN
    -- No truncamos la tabla Fact_Ventas para preservar datos históricos

    -- Limpiamos las ventas que tengan valor NULL en CodigoVenta (datos inválidos)
    DELETE
    FROM Int_Fact_Ventas
    WHERE CodigoVenta IS NULL;

	-- Por ser la tabla de hechos, es la ultima que se carga. Pero antes, 
	-- haremos las siguientes transformaciones para evitar problemas con 
	-- los Id's, Fk y Pk.

	------------------------ CLIENTES
	--- SOLUCION
	DELETE FROM Int_Fact_Ventas
	WHERE CodigoCliente = 0;

	--- SOLUCION
	UPDATE c
	SET c.RazonSocial = v.Cliente
	FROM Int_Fact_Ventas v
	LEFT JOIN Dim_Cliente c
	ON (v.CodigoCliente = c.CodigoCliente)
	WHERE c.RazonSocial = 'NaRS';

	INSERT INTO Dim_Cliente (CodigoCliente, RazonSocial, Telefono, Mail, Direccion, Localidad, Provincia, CP, FechaRegistro)
	SELECT DISTINCT 
		v.CodigoCliente, 
		v.Cliente AS RazonSocial, 
		'1' AS Telefono, 
		'NaMail' AS Mail, 
		'NaDir' AS Direccion, 
		'NaL' AS Localidad, 
		'NaP' AS Provincia, 
		'1' AS CP, 
		GETDATE() AS FechaRegistro
	FROM Int_Fact_Ventas v
	LEFT JOIN Dim_Cliente c
	ON v.Cliente = c.RazonSocial
	WHERE v.Cliente NOT IN (SELECT RazonSocial FROM Dim_Cliente);

	UPDATE v
	SET v.CodigoCliente = c.IdCliente
	FROM Int_Fact_Ventas v
	LEFT JOIN Dim_Cliente c
	ON (v.Cliente = c.RazonSocial);

	UPDATE c
	SET c.CodigoCliente = c.IdCliente
	FROM Int_Fact_Ventas v
	LEFT JOIN Dim_Cliente c
	ON (v.Cliente = c.RazonSocial);

	------------------------ TIENDA
	--- SOLUCION
	DELETE FROM Int_Fact_Ventas
	WHERE CodigoTienda = 0;

	--- SOLUCION
	UPDATE v
	SET v.Tienda = t.Descripcion
	FROM Int_Fact_Ventas v
	LEFT JOIN Dim_Tienda t
	ON v.CodigoTienda = t.CodigoTienda
	WHERE v.Tienda != t.Descripcion

	--- SOLUCION 
	UPDATE v
	SET v.CodigoTienda = t.IdTienda
	FROM Int_Fact_Ventas v
	LEFT JOIN Dim_Tienda t
	ON v.Tienda = t.Descripcion;

	UPDATE t
	SET t.CodigoTienda = t.IdTienda
	FROM Int_Fact_Ventas v
	LEFT JOIN Dim_Tienda t
	ON v.Tienda = t.Descripcion;

    -- Actualizamos los campos de la venta si existe en Fact_Ventas
    UPDATE V
    SET 
        V.FechaVenta = I.FechaVenta,
        V.CodigoProducto = I.CodigoProducto,
        V.Producto = I.Producto,
        V.Cantidad = I.Cantidad,
        V.PrecioVenta = I.PrecioVenta,
        V.CodigoCliente = I.CodigoCliente,
        V.Cliente = I.Cliente,
        V.CodigoTienda = I.CodigoTienda,
        V.Tienda = I.Tienda,
        V.FechaRegistro = GETDATE()
    FROM Fact_Ventas V
    INNER JOIN Int_Fact_Ventas I
        ON V.CodigoVenta = I.CodigoVenta;

    -- Insertamos los nuevos registros (los que no existen en Fact_Ventas)
    INSERT INTO Fact_Ventas
        ([CodigoVenta],
         [FechaVenta],
         [CodigoProducto],
         [Producto],
         [Cantidad],
         [PrecioVenta],
         [CodigoCliente],
         [Cliente],
         [CodigoTienda],
         [Tienda],
         [FechaRegistro])

    SELECT DISTINCT
        I.CodigoVenta,
        I.FechaVenta,
        I.CodigoProducto,
        I.Producto,
        I.Cantidad,
        I.PrecioVenta,
        I.CodigoCliente,
        I.Cliente,
        I.CodigoTienda,
        I.Tienda,
        GETDATE() AS FechaRegistro

    FROM Int_Fact_Ventas I
    LEFT JOIN Fact_Ventas V
        ON I.CodigoVenta = V.CodigoVenta
    WHERE V.CodigoVenta IS NULL;

	UPDATE v
	SET v.PrecioVenta = p.PrecioVentaSugerido
	FROM Fact_Ventas v
	LEFT JOIN dbo.Dim_Producto p
	ON v.CodigoProducto = p.IdProducto

END;
