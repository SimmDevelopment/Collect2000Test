SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Custom_Applied_Report_POTCYC]
@fileName varchar(250)

AS

SELECT m.account, CASE
	WHEN current0 <= 1 AND 
		EXISTS (SELECT uid FROM notes WHERE number = m.number 
			AND (action ='CY' OR result = 'CY')) 
		THEN 'CYC'
	ELSE 'PIF' END [CYC/PIF] 
FROM master m INNER JOIN Custom_Applied_Potential p
	ON m.account = p.Account INNER JOIN Fact 
	ON m.customer = customerID
WHERE p.Type = 2 AND p.FileName = @filename AND CustomGroupID = 52
ORDER BY p.ID

GO
