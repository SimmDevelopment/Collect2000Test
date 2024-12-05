SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Applied_Report_POTSIF]
@referenceDate datetime,
@fileName varchar(250)

AS

SELECT m.account, CASE
	WHEN current0 <= 0 OR status = 'PIF' THEN 'Not'
	WHEN status = 'SIF' and DATEDIFF(day, lastpaid, @referenceDate) <= 30 THEN 'SIF'
	ELSE '   ' END [SIF/PART/Not] 
FROM master m INNER JOIN Custom_Applied_Potential p
	ON m.account = p.Account INNER JOIN Fact 
	ON m.customer = customerID
WHERE p.Type = 1 AND p.FileName = @filename AND CustomGroupID = 52
ORDER BY p.ID
GO
