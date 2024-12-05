SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE  PROCEDURE [dbo].[CollectorStats_GetStatistics] @UserID INTEGER
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET ANSI_WARNINGS OFF;

DECLARE @Desk VARCHAR(10);
DECLARE @TeamID INTEGER;
DECLARE @Today DATETIME;
DECLARE @BOM DATETIME;
DECLARE @EOM DATETIME;
DECLARE @BOLM DATETIME;
DECLARE @EOLM DATETIME;
DECLARE @BONM DATETIME;
DECLARE @EONM DATETIME;

IF NOT EXISTS (SELECT * FROM [Users] WHERE [Users].[ID] = @UserID) BEGIN
	RAISERROR('User ID %d does not exist.', 16, 1, @UserID)
	RETURN -1
END

SET @Today = { fn CURDATE() };
SET @BOM = DATEADD(DAY, (DAY(@Today) * -1) + 1, @Today);
SET @EOM = DATEADD(SECOND, -1, DATEADD(MONTH, 1, @BOM));
SET @BOLM = DATEADD(MONTH, -1, @BOM);
SET @EOLM = DATEADD(SECOND, -1, DATEADD(MONTH, 1, @BOLM));
SET @BONM = DATEADD(MONTH, 1, @BOM);
SET @EONM = DATEADD(SECOND, -1, DATEADD(MONTH, 1, @BONM));

SELECT @Desk = [Users].[DeskCode]
FROM [dbo].[Users]
WHERE [Users].[ID] = @UserID;

SELECT @TeamID = [Desk].[TeamID]
FROM [dbo].[Desk]
WHERE [Desk].[code] = @Desk;

SELECT TOP 1 [ControlFile].[SoftwareVersion],
	[Users].[ID] AS [UserID],
	[Users].[UserName] AS [UserName],
	@Desk AS [DeskCode],
	[Desk].[Name] AS [Desk],
	@TeamID AS [TeamID],
	[Teams].[Name] AS [Team]
FROM [dbo].[Users]
LEFT OUTER JOIN [Desk]
ON [Desk].[code] = [Users].[DeskCode]
LEFT OUTER JOIN [Teams]
ON [Teams].[ID] = [Desk].[TeamID]
CROSS JOIN [dbo].[ControlFile]
WHERE [Users].[ID] = @UserID;

IF @Desk = '' OR @Desk IS NULL BEGIN
	RETURN 0;
END;

DECLARE @DeskContents TABLE (
	[number] INTEGER NOT NULL PRIMARY KEY,
	[qlevel] VARCHAR(3) NOT NULL,
	[qdate] DATETIME NOT NULL,
	[worked] DATETIME NULL,
	[contacted] DATETIME NULL,
	[promise] BIT NOT NULL,
	[pdc] BIT NOT NULL,
	[pcc] BIT NOT NULL,
	[nsf] BIT NOT NULL,
	[bp] BIT NOT NULL
)

INSERT INTO @DeskContents ([number], [qlevel], [qdate], [worked], [contacted], [promise], [pdc], [pcc], [nsf], [bp])
SELECT [master].[number],
	ISNULL((SELECT TOP 1 [SupportQueueItems].[QueueCode] FROM [dbo].[SupportQueueItems] WHERE [SupportQueueItems].[AccountID] = [master].[number] ORDER BY [DateAdded] ASC), [master].[qlevel]) AS [qlevel],
	CAST([master].[qdate] AS DATETIME),
	[master].[worked],
	[master].[contacted],
	CASE
		WHEN EXISTS (SELECT * FROM [dbo].[Promises] WHERE [Promises].[AcctID] = [master].[number] AND [Promises].[Active] = 1) THEN 1
		ELSE 0
	END,
	CASE
		WHEN EXISTS (SELECT * FROM [dbo].[pdc] WHERE [pdc].[number] = [master].[number] AND [pdc].[Active] = 1) THEN 1
		ELSE 0
	END,
	CASE
		WHEN EXISTS (SELECT * FROM [dbo].[DebtorCreditCards] WHERE [DebtorCreditCards].[Number] = [master].[number] AND [DebtorCreditCards].[IsActive] = 1) THEN 1
		ELSE 0
	END,
	CASE
		WHEN (SELECT TOP 1 [batchtype] FROM [dbo].[payhistory] WHERE [payhistory].[number] = [master].[number] AND [payhistory].[batchtype] LIKE 'P%' ORDER BY [payhistory].[datepaid] DESC) LIKE 'P_R' THEN 1
		ELSE 0
	END,
	CASE
		WHEN [master].[BPDate] IS NOT NULL AND [master].[BPDate] > '1900-01-01' THEN 1
		ELSE 0
	END
FROM [dbo].[master]
WHERE [master].[desk] = @Desk
AND [master].[qlevel] BETWEEN '000' AND '987';

SELECT CASE
		WHEN [worked] >= @Today THEN 1
		ELSE 0
	END AS [Worked],
	COUNT(*) AS [Total],
	ISNULL(SUM(CASE
		WHEN [promise] = 1 AND [pdc] = 0 AND [pcc] = 0 THEN 1
		ELSE 0
	END), 0) AS [Promises],
	ISNULL(SUM(CASE
		WHEN [pdc] = 1 AND [pcc] = 0 THEN 1
		ELSE 0
	END), 0) AS [PDCs],
	ISNULL(SUM(CASE
		WHEN [pcc] = 1 THEN 1
		ELSE 0
	END), 0) AS [PCCs],
	ISNULL(SUM(CASE
		WHEN [nsf] = 1 AND [promise] = 0 AND [pdc] = 0 AND [pcc] = 0 THEN 1
		ELSE 0
	END), 0) AS [NSFs],
	ISNULL(SUM(CASE
		WHEN [bp] = 1 AND [nsf] = 0 AND [promise] = 0 AND [pdc] = 0 AND [pcc] = 0 THEN 1
		ELSE 0
	END), 0) AS [BrokenPromises],
	ISNULL(SUM(CASE
		WHEN [bp] = 0 AND [nsf] = 0 AND [promise] = 0 AND [pdc] = 0 AND [pcc] = 0 AND [qlevel] BETWEEN '600' AND '699' THEN 1
		ELSE 0
	END), 0) AS [Clerical],
	ISNULL(SUM(CASE
		WHEN [bp] = 0 AND [nsf] = 0 AND [promise] = 0 AND [pdc] = 0 AND [pcc] = 0 AND [qlevel] BETWEEN '700' AND '799' THEN 1
		ELSE 0
	END), 0) AS [Supervisor],
	ISNULL(SUM(CASE
		WHEN [bp] = 0 AND [nsf] = 0 AND [promise] = 0 AND [pdc] = 0 AND [pcc] = 0 AND [qlevel] BETWEEN '800' AND '997' THEN 1
		ELSE 0
	END), 0) AS [Hold],
	ISNULL(SUM(CASE
		WHEN [bp] = 0 AND [nsf] = 0 AND [promise] = 0 AND [pdc] = 0 AND [pcc] = 0 AND [qlevel] < '600' AND [qdate] >= @Today THEN 1
		ELSE 0
	END), 0) AS [Followup]
FROM @DeskContents
GROUP BY CASE
		WHEN [worked] >= @Today THEN 1
		ELSE 0
	END
ORDER BY [Worked] ASC;

SELECT @BOM AS [Month],
	COUNT(DISTINCT [Promises].[AcctID]) AS [Accounts],
	ISNULL(SUM([Promises].[Amount]), 0) AS [PromiseAmount]
FROM [master]
INNER JOIN [Promises]
ON [master].[number] = [Promises].[AcctID]
WHERE [master].[desk] = @Desk
AND [Promises].[DueDate] BETWEEN @BOM AND @EOM
UNION
SELECT @BONM AS [Month],
	COUNT(DISTINCT [Promises].[AcctID]) AS [Accounts],
	ISNULL(SUM([Promises].[Amount]), 0) AS [PromiseAmount]
FROM [master]
INNER JOIN [Promises]
ON [master].[number] = [Promises].[AcctID]
WHERE [master].[desk] = @Desk
AND [Promises].[DueDate] BETWEEN @BONM AND @EONM
ORDER BY [Month] ASC;

SELECT @BOM AS [Month],
	COUNT(DISTINCT [pdc].[number]) AS [Accounts],
	ISNULL(SUM([pdc].[amount]), 0) AS [PDCAmount]
FROM [master]
INNER JOIN [pdc]
ON [master].[number] = [pdc].[number]
WHERE [master].[desk] = @Desk
AND [pdc].[deposit] BETWEEN @BOM AND @EOM
UNION
SELECT @BONM AS [Month],
	COUNT(DISTINCT [pdc].[number]) AS [Accounts],
	ISNULL(SUM([pdc].[amount]), 0) AS [PDCAmount]
FROM [master]
INNER JOIN [pdc]
ON [master].[number] = [pdc].[number]
WHERE [master].[desk] = @Desk
AND [pdc].[deposit] BETWEEN @BONM AND @EONM
ORDER BY [Month] ASC;

SELECT @BOM AS [Month],
	COUNT(DISTINCT [DebtorCreditCards].[Number]) AS [Accounts],
	ISNULL(SUM([DebtorCreditCards].[Amount]), 0) AS [PCCAmount]
FROM [master]
INNER JOIN [DebtorCreditCards]
ON [master].[number] = [DebtorCreditCards].[Number]
WHERE [master].[desk] = @Desk
AND [DebtorCreditCards].[DepositDate] BETWEEN @BOM AND @EOM
UNION
SELECT @BONM AS [Month],
	COUNT(DISTINCT [DebtorCreditCards].[Number]) AS [Accounts],
	ISNULL(SUM([DebtorCreditCards].[Amount]), 0) AS [PCCAmount]
FROM [master]
INNER JOIN [DebtorCreditCards]
ON [master].[number] = [DebtorCreditCards].[Number]
WHERE [master].[desk] = @Desk
AND [DebtorCreditCards].[DepositDate] BETWEEN @BONM AND @EONM
ORDER BY [Month] ASC;

DECLARE @TMPPAFee MONEY;
DECLARE @TMPPANSFFee MONEY;
DECLARE @LMPPAFee MONEY;
DECLARE @LMPPANSFFee MONEY;

SELECT @BOM AS [Month],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN 1
		ELSE 0
	END), 0) AS [Payments],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN 1
		ELSE 0
	END), 0) AS [NSFs],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [payhistory].[totalpaid] - [payhistory].[OverPaidAmt]
		ELSE 0
	END), 0) AS [PaymentAmount],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN [payhistory].[totalpaid] - [payhistory].[OverPaidAmt]
		ELSE 0
	END), 0) AS [NSFAmount],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]
		ELSE 0
	END), 0) AS [PaymentFee],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN [payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]
		ELSE 0
	END), 0) AS [NSFFee]
FROM [payhistory]
WHERE [payhistory].[datepaid] BETWEEN @BOM AND @EOM
AND [payhistory].[desk] = @Desk
AND [payhistory].[batchtype] LIKE 'P_%'
UNION
SELECT @BOLM AS [Month],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN 1
		ELSE 0
	END), 0) AS [Payments],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN 1
		ELSE 0
	END), 0) AS [NSFs],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [payhistory].[totalpaid] - [payhistory].[OverPaidAmt]
		ELSE 0
	END), 0) AS [PaymentAmount],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN [payhistory].[totalpaid] - [payhistory].[OverPaidAmt]
		ELSE 0
	END), 0) AS [NSFAmount],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]
		ELSE 0
	END), 0) AS [PaymentFee],
	ISNULL(SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN [payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]
		ELSE 0
	END), 0) AS [NSFFee]
FROM [payhistory]
WHERE [payhistory].[datepaid] BETWEEN @BOLM AND @EOLM
AND [payhistory].[desk] = @Desk
AND [payhistory].[batchtype] LIKE 'P_%'
ORDER BY [Month] DESC;

DECLARE @PdcTieBreaker TABLE (
	[desk] VARCHAR(10) NOT NULL PRIMARY KEY,
	[amount] MONEY NOT NULL
)

INSERT INTO @PdcTieBreaker ([desk], [amount])
SELECT [desk].[code],
	ISNULL(SUM([pdc].[amount]), 0)
FROM [desk]
LEFT OUTER JOIN [pdc]
ON [pdc].[desk] = [desk].[code]
WHERE [desk].[TeamID] = @TeamID
AND [pdc].[deposit] BETWEEN @BOM AND @EONM
GROUP BY [desk].[code]

SELECT [desk].[code] AS [DeskCode],
	[desk].[name] AS [Desk],
	SUM(CASE 
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN 1
		ELSE 0
	END) AS [Payments],
	SUM(CASE 
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN 1
		ELSE 0
	END) AS [NSFs],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [payhistory].[totalpaid] - [payhistory].[OverPaidAmt]
		ELSE 0
	END) AS [PaymentAmount],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN [payhistory].[totalpaid] - [payhistory].[OverPaidAmt]
		ELSE 0
	END) AS [NSFAmount],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]
		ELSE 0
	END) AS [PaymentFee],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN [payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]
		ELSE 0
	END) AS [NSFFee],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
		ELSE 0
	END) AS [CurrentFee],
	ISNULL([pdc].[amount], 0) AS [FuturePDC]
FROM [desk]
LEFT OUTER JOIN [payhistory]
ON [payhistory].[desk] = [desk].[code]
AND [payhistory].[batchtype] LIKE 'P_%'
AND [payhistory].[datepaid] BETWEEN @BOM AND @EOM
LEFT OUTER JOIN @PdcTieBreaker AS [pdc]
ON [pdc].[desk] = [desk].[code]
WHERE [desk].[TeamID] = @TeamID
AND [desk].[desktype] = 'Collector'
GROUP BY [desk].[code],
	[desk].[name],
	[pdc].[amount]
ORDER BY [CurrentFee] DESC,
	[pdc].[amount] DESC;

SELECT [desk].[code] AS [DeskCode],
	[desk].[name] AS [Desk],
	SUM(CASE 
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN 1
		ELSE 0
	END) AS [Payments],
	SUM(CASE 
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN 1
		ELSE 0
	END) AS [NSFs],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [payhistory].[totalpaid] - [payhistory].[OverPaidAmt]
		ELSE 0
	END) AS [PaymentAmount],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN [payhistory].[totalpaid] - [payhistory].[OverPaidAmt]
		ELSE 0
	END) AS [NSFAmount],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]
		ELSE 0
	END) AS [PaymentFee],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN [payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]
		ELSE 0
	END) AS [NSFFee],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
		ELSE 0
	END) AS [CurrentFee],
	ISNULL([pdc].[amount], 0) AS [FuturePDC]
FROM [desk]
LEFT OUTER JOIN [payhistory]
ON [payhistory].[desk] = [desk].[code]
AND [payhistory].[batchtype] LIKE 'P_%'
AND [payhistory].[datepaid] BETWEEN @BOLM AND @EOLM
LEFT OUTER JOIN @PdcTieBreaker AS [pdc]
ON [pdc].[desk] = [desk].[code]
WHERE [desk].[TeamID] = @TeamID
AND [desk].[desktype] = 'Collector'
GROUP BY [desk].[code],
	[desk].[name],
	[pdc].[amount]
ORDER BY [CurrentFee] DESC,
	[pdc].[amount] DESC;






GO
