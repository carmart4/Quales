--- Archivo para verificar las cargas de cada procedimiento almacenado. 
USE DW_DataShop;

SELECT * FROM Stg_Dim_Provincia
SELECT * FROM Int_Dim_Provincia
SELECT * FROM Dim_Provincia

SELECT * FROM Stg_Dim_Almacen
SELECT * FROM Int_Dim_Almacen
SELECT * FROM Dim_Almacen

SELECT * FROM Stg_Dim_Proveedor
SELECT * FROM Int_Dim_Proveedor
SELECT * FROM Dim_Proveedor

SELECT * FROM Stg_Dim_Estado
SELECT * FROM Int_Dim_Estado
SELECT * FROM Dim_Estado

SELECT * FROM dbo.Dim_Tiempo

SELECT * FROM Stg_Check_Entrega
SELECT * FROM Int_Check_Entrega
SELECT * FROM Check_Entrega