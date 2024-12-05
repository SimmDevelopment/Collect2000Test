SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_GetInventorySummary]
	    
 AS

SELECT desk.code + ' - ' + desk.name as DeskCodeDesc, count(master.number), sum(master.current0) 
FROM master INNER JOIN desk on master.desk = desk.code 
WHERE  master.qlevel < '998' 
            	GROUP BY desk.code, desk.name ORDER BY desk.code



/*
/This is the original version
CREATE PROCEDURE SP_GetInventorySummary
	    
 AS

SELECT desk.code + ' - ' + desk.name as DeskCodeDesc, count(master.number), sum(master.current0) 
FROM master INNER JOIN desk on master.desk = desk.code 
WHERE master.desk in (SELECT DISTINCT  code FROM desk 
			WHERE desktype = 'collector') 
	and master.qlevel < '998' 
            	GROUP BY desk.code, desk.name ORDER BY desk.code    */


GO
