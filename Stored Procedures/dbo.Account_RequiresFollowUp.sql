SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE    PROCEDURE [dbo].[Account_RequiresFollowUp] @AccountID INTEGER 
AS
SET NOCOUNT ON;

DECLARE @RequiresFollowUp INTEGER;

SELECT @RequiresFollowUp = CASE
		WHEN LEFT([status].[statustype], 1) = '1' THEN 0
		WHEN EXISTS (SELECT * FROM [dbo].[Reminders] WHERE [Reminders].[AccountID] = [master].[number]) THEN 0
		WHEN EXISTS (SELECT * FROM [dbo].[pdc] WHERE [pdc].[number] = [master].[number] AND [pdc].[Active] = 1) THEN 0
		WHEN EXISTS (SELECT * FROM [dbo].[Promises] WHERE [Promises].[AcctID] = [master].[number] AND [Promises].[Active] = 1) THEN 0
		WHEN EXISTS (SELECT * FROM [dbo].[DebtorCreditCards] WHERE [DebtorCreditCards].[Number] = [master].[number] AND [DebtorCreditCards].[IsActive] = 1) THEN 0
		WHEN ISDATE([master].[qdate]) = 1 AND CAST([master].[qdate] AS DATETIME) > GETDATE() THEN 0
		WHEN [master].[qlevel] BETWEEN '400' AND '404' THEN 0
		WHEN [master].[qlevel] = '000' THEN 0
		WHEN [master].[qlevel] >= '800' THEN 0
		WHEN [master].[ShouldQueue] = 0 THEN 0
		ELSE 1
	END 
FROM [dbo].[master]
INNER JOIN [dbo].[status]
ON [master].[status] = [status].[code]
WHERE [master].[number] = @AccountID;

RETURN @RequiresFollowUp;




GO
