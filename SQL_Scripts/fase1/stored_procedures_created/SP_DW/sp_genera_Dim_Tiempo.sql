------------------------------------------------------------------------- Stored Procedure que genera la informacion para Dim_Tiempo
USE DW_DataShop;

GO
CREATE PROCEDURE [dbo].[Sp_Genera_Dim_Tiempo] 
	@anio Int -- Parametro para crear toda la informaci�n que corresponda a dicho a�o
AS 
BEGIN
    SET NOCOUNT ON;
    SET ARITHABORT OFF;
    SET ARITHIGNORE ON;
    SET DATEFIRST 1;
    SET DATEFORMAT mdy;

    /**************/
    /* Variables */
    /**************/
    DECLARE @dia smallint;
    DECLARE @mes smallint;
    DECLARE @f_txt varchar(10);
    DECLARE @fecha smalldatetime;
    DECLARE @key int;
    DECLARE @vacio smallint;
    DECLARE @fin smallint;
    DECLARE @fin_mes int;
    DECLARE @anioperiodicidad int;
    
    SELECT @dia = 1, @mes = 1;
    SELECT @f_txt = Convert(char(2), @mes) + '/' + Convert(char(2), @dia) + '/' + Convert(char(4), @anio);
    SELECT @fecha = Convert(smalldatetime, @f_txt);
    SELECT @anioperiodicidad = @anio;

    /************************************/
    /* Se chequea que el a�o a procesar */
    /* no exista en la tabla TIME       */
    /************************************/
    IF (SELECT Count(*) FROM Dim_Tiempo WHERE anio = @anio) > 0 
    BEGIN
        PRINT 'El a�o que ingres� ya existe en la tabla';
        PRINT 'Procedimiento CANCELADO.................';
        RETURN 0;
    END;

    /*************************/
    /* Se inserta d�a a d�a   */
    /* hasta terminar el a�o  */
    /*************************/
    SELECT @fin = @anio + 1;

    WHILE (Year(@fecha) < @fin) 
    BEGIN
        --Armo la fecha
        SET @f_txt = Convert(char(4), Datepart(yyyy, @fecha)) + 
                     RIGHT('0' + Convert(varchar(2), Datepart(mm, @fecha)), 2) +
                     RIGHT('0' + Convert(varchar(2), Datepart(dd, @fecha)), 2);
        
        --Calculo el �ltimo d�a del mes
        SET @fin_mes = Day(Dateadd(d, -1, Dateadd(m, 1, Dateadd(d, - Day(@fecha) + 1, @fecha))));
        
        --Inserto el registro
        INSERT Dim_Tiempo (Tiempo_Key, Anio, Mes, Mes_Nombre, Semestre, Trimestre, Semana_Anio ,Semana_Nro_Mes, Dia, Dia_Nombre, Dia_Semana_Nro)
        SELECT 
            tiempo_key = @fecha,
            anio = Datepart(yyyy, @fecha),
            mes = Datepart(mm, @fecha),
            mes_nombre = CASE Datename(mm, @fecha)
                WHEN 'January' THEN 'Enero'
                WHEN 'February' THEN 'Febrero'
				WHEN 'March' THEN 'Marzo'
				WHEN 'April' THEN 'Abril'
				WHEN 'May' THEN 'Mayo'
				WHEN 'June' THEN 'Junio'
				WHEN 'July' THEN 'Julio'
				WHEN 'August' THEN 'Agosto'
				WHEN 'September' THEN 'Septiembre'
				WHEN 'October' THEN 'Octubre'
				WHEN 'November' THEN 'Noviembre'
				WHEN 'December' THEN 'Diciembre'
                ELSE Datename(mm, @fecha)
            END,
            semestre = CASE WHEN Datepart(mm, @fecha) BETWEEN 1 AND 6 THEN 1 ELSE 2 END,
            trimestre = Datepart(qq, @fecha),
            semana_anio = Datepart(wk, @fecha),
            semana_nro_mes = Datepart(wk, @fecha) - Datepart(week, Dateadd(dd, -Day(@fecha)+1, @fecha)) + 1,
            dia = Datepart(dd, @fecha),
            dia_nombre = CASE Datename(dw, @fecha)
                WHEN 'Monday' THEN 'Lunes'
                WHEN 'Tuesday' THEN 'Martes'
                WHEN 'Wednesday' THEN 'Mi�rcoles'
				WHEN 'Thursday' THEN 'Jueves'
				WHEN 'Friday' THEN 'Viernes'
				WHEN 'Saturday' THEN 'S�bado'
				WHEN 'Sunday' THEN 'Domingo'
                ELSE Datename(dw, @fecha)
            END,
            dia_semana_nro = Datepart(dw, @fecha);
        
        -- Incremento la fecha
        SELECT @fecha = Dateadd(dd, 1, @fecha);
    END;
END;