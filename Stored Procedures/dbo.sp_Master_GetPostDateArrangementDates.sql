SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Master_GetPostDateArrangementDates] @AccountID INTEGER
AS
SET NOCOUNT ON;

SELECT [number],
	(SELECT TOP 1 [Promises].[Entered]
	FROM [dbo].[Promises]
	WHERE [Promises].[AcctID] = [master].[number]
	AND [Promises].[Active] = 1
	ORDER BY [Promises].[Entered] ASC) AS [PromiseEntered],
	(SELECT TOP 1 [pdc].[entered]
	FROM [dbo].[pdc]
	WHERE [pdc].[number] = [master].[number]
	AND [pdc].[Active] = 1
	ORDER BY [pdc].[entered] ASC) AS [PDCEntered],
	(SELECT TOP 1 [DebtorCreditCards].[DateEntered]
	FROM [dbo].[DebtorCreditCards]
	WHERE [DebtorCreditCards].[Number] = [master].[number]
	AND [DebtorCreditCards].[IsActive] = 1
	ORDER BY [DebtorCreditCards].[DateEntered] ASC) AS [PCCEntered]
FROM [dbo].[master]
WHERE [master].[number] = @AccountID;

RETURN 0;


GO
