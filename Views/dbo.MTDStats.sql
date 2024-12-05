SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[MTDStats]
AS
SELECT DISTINCT 
                      dbo.desk.code, SUM(dbo.payhistory.totalpaid) AS Collections, 
                      SUM(dbo.payhistory.fee1 + dbo.payhistory.fee2 + dbo.payhistory.fee3 + dbo.payhistory.fee4 + dbo.payhistory.fee5 + dbo.payhistory.fee6 + dbo.payhistory.fee7
                       + dbo.payhistory.fee8 + dbo.payhistory.fee9 + dbo.payhistory.fee10) AS Fees, dbo.payhistory.systemmonth, dbo.payhistory.systemyear
FROM         dbo.desk LEFT OUTER JOIN
                      dbo.payhistory ON dbo.payhistory.desk = dbo.desk.code
GROUP BY dbo.desk.code, dbo.payhistory.systemmonth, dbo.payhistory.systemyear
GO
