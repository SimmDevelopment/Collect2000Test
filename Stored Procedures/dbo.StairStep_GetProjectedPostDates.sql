SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[StairStep_GetProjectedPostDates]
	@CustomerCode VARCHAR(7),
	@EomDate DATETIME = NULL
WITH RECOMPILE
AS
SET NOCOUNT ON;

SELECT
	'pdc' AS [type],
	[p].[UID],
	CASE
		WHEN [pd].[AccountID] IS NOT NULL AND [p].[number] <> [pd].[AccountID]
		THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END AS [linked],
	COALESCE([pd].[Amount], [p].[amount]) AS [amount],
	[p].[deposit],
	[m].[sysmonth],
	[m].[sysyear]
FROM [dbo].[pdc] AS [p]
LEFT OUTER JOIN [dbo].[PdcDetails] AS [pd]
ON [p].[UID] = [pd].[PdcID]
INNER JOIN (SELECT number,customer,sysmonth,sysyear FROM [dbo].[master]) AS [m]
ON [m].number=COALESCE([pd].[Accountid],[p].[number])
WHERE [m].[customer] = @CustomerCode
AND [p].[onhold] IS NULL
AND [p].[active] = 1
AND (@EomDate IS NULL
	OR [p].[deposit] <= @EomDate)
UNION ALL
SELECT
	'pcc' AS [type],
	[c].[ID],
	CASE
		WHEN [cd].[AccountID] IS NOT NULL AND [c].[number] <> [cd].[AccountID]
		THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END AS [linked],
	COALESCE([cd].[Amount], [c].[Amount]) AS [amount],
	[c].[DepositDate] AS [deposit],
	[m].[sysmonth],
	[m].[sysyear]
FROM [dbo].[DebtorCreditCards] AS [c]
LEFT OUTER JOIN [dbo].[DebtorCreditCardDetails] AS [cd]
ON [c].[ID] = [cd].[DebtorCreditCardID]
INNER JOIN (SELECT number,customer,sysmonth,sysyear FROM [dbo].[master]) AS [m]
ON [m].number=COALESCE([cd].[AccountID],[c].[number])
WHERE [m].[customer] = @CustomerCode
AND [c].[OnHoldDate] IS NULL
AND [c].[IsActive] = 1
AND (@EomDate IS NULL
	OR [c].[DepositDate] <= @EomDate)
ORDER BY [deposit] DESC;

RETURN 0;


GO
