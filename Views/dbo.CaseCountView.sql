SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*CaseCountView*/
CREATE VIEW [dbo].[CaseCountView]
AS
SELECT     TOP 100 PERCENT D.code, COUNT(m.number) AS CaseCount
FROM         dbo.desk D FULL OUTER JOIN
                      dbo.master m ON m.desk = D.code LEFT OUTER JOIN
                      dbo.status s ON m.status = s.code AND s.CaseCount = 1
GROUP BY D.code
ORDER BY D.code

GO
