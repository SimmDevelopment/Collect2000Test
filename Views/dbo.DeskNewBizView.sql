SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*DeskNewBizView*/
CREATE VIEW [dbo].[DeskNewBizView]
AS
SELECT     TOP 100 PERCENT D.code, COUNT(m.number) AS NewBizCount, SUM(m.original) AS NewBizAmt
FROM         dbo.desk D FULL OUTER JOIN
                      dbo.master m ON m.desk = D.code LEFT OUTER JOIN
                      dbo.controlFile c ON m.sysmonth = c.currentmonth AND m.SysYear = c.currentyear
GROUP BY D.code
ORDER BY D.code

GO
