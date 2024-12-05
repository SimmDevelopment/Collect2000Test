SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Phones_GetAccountByPhone] @PhoneNumber VARCHAR(30)
AS
SET NOCOUNT ON;

SELECT TOP 1 [master].[number] AS [AccountID],
	[Debtors].[DebtorID] AS [DebtorID],
	[Debtors].[Seq] AS [Sequence]
FROM [dbo].[master]
INNER JOIN [dbo].[Phones_Master] 
ON [Phones_Master].[Number] = [master].[number]
LEFT OUTER JOIN [dbo].[Phones_Statuses]
ON [Phones_Master].[PhoneStatusID] = [Phones_Statuses].[PhoneStatusID]
INNER JOIN [dbo].[Debtors]
ON [Phones_Master].[Number] = [Debtors].[number]
AND ([Phones_Master].[DebtorID] = [Debtors].[DebtorID]
	OR ([Phones_Master].[DebtorID] IS NULL
		AND [Debtors].[Seq] = [master].[PSeq]))
WHERE [Phones_Master].[PhoneNumber] = @PhoneNumber
ORDER BY CASE
		WHEN [master].[qlevel] IN ('998', '999') THEN 0
		ELSE 1
	END DESC,
	CASE
		WHEN [Phones_Statuses].[Active] IS NULL THEN 1
		WHEN [Phones_Statuses].[Active] = 1 THEN 2
		ELSE 0
	END DESC;

RETURN 0;

GO
