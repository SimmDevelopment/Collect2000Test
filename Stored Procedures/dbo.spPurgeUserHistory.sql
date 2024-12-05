SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spPurgeUserHistory] @RetainDays INT = 90
AS 
    BEGIN

		SET NOCOUNT ON
		
        DECLARE @HistTblNm VARCHAR(100) 
        DECLARE @HistPrefix INT 
        DECLARE @SQL NVARCHAR(MAX)

        SET @HistPrefix = LEN('HISTORY')

        DECLARE UsrHistTbls CURSOR FORWARD_ONLY STATIC 
        FOR 
        SELECT 	QUOTENAME(t.table_name)
        FROM 	information_schema.tables t 
        WHERE  	t.table_type = 'base table'
        AND		t.table_schema = 'dbo' 
        AND 	t.table_name LIKE 'history%' 
        AND		LEN(t.table_name)>@HistPrefix 

        OPEN	UsrHistTbls 

        FETCH NEXT FROM UsrHistTbls INTO @HistTblNm 


        WHILE @@FETCH_STATUS <> -1 
            BEGIN
    
                SET @SQL = 'WHILE @@ROWCOUNT<>0 BEGIN delete TOP (10000) from ' + @HistTblNm + ' where DATEADD(dd,-' + CAST(@RetainDays AS NVARCHAR(15)) + ',GETDATE()) > Thedate end' 
                EXEC (@SQL)
                FETCH NEXT FROM UsrHistTbls INTO @HistTblNm 

            END 


        CLOSE UsrHistTbls 

        DEALLOCATE UsrHistTbls 

    END

GO
