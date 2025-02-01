--- Archivo para verificar las cargas de cada procedimiento almacenado. 
USE DW_DataShop;

SELECT * FROM Stg_Dim_Cliente
SELECT * FROM Int_Dim_Cliente
SELECT * FROM Dim_Cliente

SELECT * FROM Stg_Dim_Producto
SELECT * FROM Int_Dim_Producto
SELECT * FROM Dim_Producto

SELECT * FROM Stg_Dim_Tienda
SELECT * FROM Int_Dim_Tienda
SELECT * FROM Dim_Tienda

SELECT * FROM dbo.Dim_Tiempo

SELECT * FROM Stg_Fact_Ventas
SELECT * FROM Int_Fact_Ventas
SELECT * FROM Fact_Ventas