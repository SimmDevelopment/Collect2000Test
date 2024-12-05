SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE   PROCEDURE [dbo].[ManagerDashboard_GetStatistics]
AS
SET NOCOUNT OFF;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @Today DATETIME;
DECLARE @BOM DATETIME;
DECLARE @EOM DATETIME;

DECLARE @SystemMonth TINYINT;
DECLARE @SystemYear SMALLINT;

SET @Today = { fn CURDATE() };
SET @BOM = DATEADD(DAY, -(DAY(@Today) - 1), @Today);

SELECT TOP 1 @EOM = [eomdate]
FROM [ControlFile];

SET @EOM = DATEADD(SECOND, -1, DATEADD(DAY, 1, @EOM));

SELECT TOP 1 @SystemMonth = [CurrentMonth],
	@SystemYear = [CurrentYear]
FROM [ControlFile];

DECLARE @WorkStats TABLE (
	[Desk] VARCHAR(10) NOT NULL,
	[Touched] INTEGER NOT NULL,
	[Worked] INTEGER NOT NULL,
	[Contacted] INTEGER NOT NULL,
	[Attempts] INTEGER NOT NULL
);

DECLARE @Promises TABLE (
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL
);

DECLARE @PDCs TABLE (
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[ProjectedFee] MONEY NOT NULL
);

DECLARE @PCCs TABLE (
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[ProjectedFee] MONEY NOT NULL
);

DECLARE @Paid TABLE (
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[Fee] MONEY NOT NULL
);

DECLARE @NSF TABLE (
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[Fee] MONEY NOT NULL
);

DECLARE @Collected TABLE (
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[Fee] MONEY NOT NULL
);

DECLARE @Reversed TABLE (
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[Fee] MONEY NOT NULL
);

DECLARE @RemainingPDCs TABLE (
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[ProjectedFee] MONEY NOT NULL
);

DECLARE @RemainingPCCs TABLE (
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[ProjectedFee] MONEY NOT NULL
);

INSERT INTO @WorkStats ([Desk], [Touched], [Worked], [Contacted], [Attempts])
SELECT [desk].[code] AS [DeskCode],
	ISNULL(SUM([DeskStats].[Touched]), 0) AS [Touched],
	ISNULL(SUM([DeskStats].[Worked]), 0) AS [Worked],
	ISNULL(SUM([DeskStats].[Contacted]), 0) AS [Contacted],
	ISNULL(SUM([DeskStats].[Attempts]), 0) AS [Attempts]
FROM [desk]
INNER JOIN [Users]
ON [desk].[code] = [Users].[DeskCode]
INNER JOIN [DeskStats]
ON [Users].[LoginName] = [DeskStats].[Desk]
WHERE [DeskStats].[TheDate] = @Today
GROUP BY [desk].[code]
ORDER BY [DeskCode];

INSERT INTO @Promises ([Desk], [Accounts], [Amount])
SELECT [desk].[code] AS [DeskCode],
	COUNT(DISTINCT [Promises].[AcctID]) AS [Accounts],
	ISNULL(SUM([Promises].[Amount]), 0) AS [Amount]
FROM [desk]
INNER JOIN [Promises]
ON [desk].[code] = [Promises].[Desk]
WHERE [Promises].[Entered] = @Today
AND [Promises].[DueDate] <= @EOM
AND [Promises].[Active] = 1
AND ([Promises].[Suspended] = 1
	OR [Promises].[Suspended] IS NULL)
GROUP BY [desk].[code];

INSERT INTO @PDCs ([Desk], [Accounts], [Amount], [ProjectedFee])
SELECT [desk].[code] AS [DeskCode],
	COUNT(DISTINCT [pdc].[number]) AS [Accounts],
	ISNULL(SUM([pdc].[amount]), 0) AS [Amount],
	ISNULL(SUM([pdc].[ProjectedFee]), 0) AS [ProjectedFee]
FROM [desk]
INNER JOIN [pdc]
ON [desk].[code] = [pdc].[desk]
WHERE [pdc].[entered] = @Today
AND [pdc].[deposit] <= @EOM
AND [pdc].[Active] = 1
GROUP BY [desk].[code];

INSERT INTO @PCCs ([Desk], [Accounts], [Amount], [ProjectedFee])
SELECT [desk].[code] AS [DeskCode],
	COUNT(DISTINCT [DebtorCreditCards].[number]) AS [Accounts],
	ISNULL(SUM([DebtorCreditCards].[amount]), 0) AS [Amount],
	ISNULL(SUM([DebtorCreditCards].[ProjectedFee]), 0) AS [ProjectedFee]
FROM [DebtorCreditCards]
INNER JOIN [master]
ON [DebtorCreditCards].[Number] = [master].[number]
INNER JOIN [desk]
ON [desk].[code] = [master].[desk]
WHERE [DebtorCreditCards].[DateEntered] = @Today
AND [DebtorCreditCards].[DepositDate] <= @EOM
AND [DebtorCreditCards].[IsActive] = 1
GROUP BY [desk].[code];

INSERT INTO @Paid ([Desk], [Accounts], [Amount], [Fee])
SELECT [desk].[code] AS [DeskCode],
	COUNT(DISTINCT [payhistory].[number]) AS [Accounts],
	ISNULL(SUM([payhistory].[TotalPaid] - [payhistory].[OverPaidAmt]), 0) AS [Amount],
	ISNULL(SUM([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]), 0) AS [Fees]
FROM [desk]
INNER JOIN [payhistory]
ON [desk].[code] = [payhistory].[desk]
WHERE [payhistory].[entered] = @Today
AND [payhistory].[batchtype] IN ('PU', 'PC', 'PA')
GROUP BY [desk].[code];

INSERT INTO @NSF ([Desk], [Accounts], [Amount], [Fee])
SELECT [desk].[code] AS [DeskCode],
	COUNT(DISTINCT [payhistory].[number]) AS [Accounts],
	ISNULL(SUM([payhistory].[TotalPaid] - [payhistory].[OverPaidAmt]), 0) AS [Amount],
	ISNULL(SUM([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]), 0) AS [Fees]
FROM [desk]
INNER JOIN [payhistory]
ON [desk].[code] = [payhistory].[desk]
WHERE [payhistory].[entered] = @Today
AND [payhistory].[batchtype] IN ('PUR', 'PCR', 'PAR')
GROUP BY [desk].[code];

INSERT INTO @Collected ([Desk], [Accounts], [Amount], [Fee])
SELECT [desk].[code] AS [DeskCode],
	COUNT(DISTINCT [payhistory].[number]) AS [Accounts],
	ISNULL(SUM([payhistory].[TotalPaid] - [payhistory].[OverPaidAmt]), 0) AS [Amount],
	ISNULL(SUM([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]), 0) AS [Fees]
FROM [desk]
INNER JOIN [payhistory]
ON [desk].[code] = [payhistory].[desk]
WHERE [payhistory].[systemyear] = @SystemYear
AND [payhistory].[systemmonth] = @SystemMonth
AND [payhistory].[batchtype] IN ('PU', 'PC', 'PA')
GROUP BY [desk].[code];

INSERT INTO @Reversed ([Desk], [Accounts], [Amount], [Fee])
SELECT [desk].[code] AS [DeskCode],
	COUNT(DISTINCT [payhistory].[number]) AS [Accounts],
	ISNULL(SUM([payhistory].[TotalPaid] - [payhistory].[OverPaidAmt]), 0) AS [Amount],
	ISNULL(SUM([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]), 0) AS [Fees]
FROM [desk]
INNER JOIN [payhistory]
ON [desk].[code] = [payhistory].[desk]
WHERE [payhistory].[systemyear] = @SystemYear
AND [payhistory].[systemmonth] = @SystemMonth
AND [payhistory].[batchtype] IN ('PUR', 'PCR', 'PAR')
GROUP BY [desk].[code];

INSERT INTO @RemainingPDCs ([Desk], [Accounts], [Amount], [ProjectedFee])
SELECT [desk].[code] AS [DeskCode],
	COUNT(DISTINCT [pdc].[number]) AS [Accounts],
	ISNULL(SUM([pdc].[amount]), 0) AS [Amount],
	ISNULL(SUM([pdc].[ProjectedFee]), 0) AS [ProjectedFee]
FROM [desk]
INNER JOIN [master]
ON [desk].[code] = [master].[desk]
INNER JOIN [pdc]
ON [master].[number] = [pdc].[number]
WHERE [pdc].[deposit] <= @EOM
AND [pdc].[Active] = 1
AND [pdc].[onhold] IS NULL
GROUP BY [desk].[code];

INSERT INTO @RemainingPCCs ([Desk], [Accounts], [Amount], [ProjectedFee])
SELECT [desk].[code] AS [DeskCode],
	COUNT(DISTINCT [DebtorCreditCards].[number]) AS [Accounts],
	ISNULL(SUM([DebtorCreditCards].[amount]), 0) AS [Amount],
	ISNULL(SUM([DebtorCreditCards].[ProjectedFee]), 0) AS [ProjectedFee]
FROM [desk]
INNER JOIN [master]
ON [desk].[code] = [master].[desk]
INNER JOIN [DebtorCreditCards] 
ON [master].[number] = [DebtorCreditCards].[number]
WHERE [DebtorCreditCards].[DepositDate] <= @EOM
AND [DebtorCreditCards].[IsActive] = 1
AND [DebtorCreditCards].[onholdDate] IS NULL
GROUP BY [desk].[code];

SELECT [desk].[code] AS [DeskCode],
	[desk].[name] AS [DeskName],
	UPPER([desk].[desktype]) AS [DeskType],
	[Teams].[ID] AS [TeamID],
	[Teams].[Name] AS [Team],
	[Departments].[ID] As [DepartmentID],
	[Departments].[Name] AS [Department],
	[Departments].[Branch] AS [Branch],
	[BranchCodes].[Name] AS [BranchName],
	ISNULL([WorkStats].[Touched], 0) AS [Touched],
	ISNULL([WorkStats].[Worked], 0) AS [Worked],
	ISNULL([WorkStats].[Contacted], 0) AS [Contacted],
	ISNULL([WorkStats].[Attempts], 0) AS [Attempts],
	ISNULL([Promises].[Accounts], 0) AS [PromisedAccounts],
	ISNULL([Promises].[Amount], 0) AS [PromisedAmount],
	ISNULL([PDCs].[Accounts], 0) AS [PDCAccounts],
	ISNULL([PDCs].[Amount], 0) AS [PDCAmount],
	ISNULL([PDCs].[ProjectedFee], 0) AS [PDCProjectedFee],
	ISNULL([PCCs].[Accounts], 0) AS [PCCAccounts],
	ISNULL([PCCs].[Amount], 0) AS [PCCAmount],
	ISNULL([PCCs].[ProjectedFee], 0) AS [PCCProjectedFee],
	ISNULL([Paid].[Accounts], 0) AS [PaidAccounts],
	ISNULL([Paid].[Amount], 0) AS [PaidAmount],
	ISNULL([Paid].[Fee], 0) AS [PaidFee],
	ISNULL([NSF].[Accounts], 0) AS [NSFAccounts],
	ISNULL([NSF].[Amount], 0) AS [NSFAmount],
	ISNULL([NSF].[Fee], 0) AS [NSFFee],
	ISNULL([Collected].[Accounts], 0) AS [MTDPaidAccounts],
	ISNULL([Collected].[Amount], 0) AS [MTDPaidAmount],
	ISNULL([Collected].[Fee], 0) AS [MTDPaidFee],
	ISNULL([Reversed].[Accounts], 0) AS [MTDNSFAccounts],
	ISNULL([Reversed].[Amount], 0) AS [MTDNSFAmount],
	ISNULL([Reversed].[Fee], 0) AS [MTDNSFFee],
	ISNULL([Collected].[Accounts], 0) - ISNULL([Reversed].[Accounts], 0) AS [MTDCollectedAccounts],
	ISNULL([Collected].[Amount], 0) - ISNULL([Reversed].[Amount], 0) AS [MTDCollectedAmount],
	ISNULL([Collected].[Fee], 0) - ISNULL([Reversed].[Fee], 0) AS [MTDCollectedFee],
	ISNULL([RemainingPDCs].[Accounts], 0) AS [RemainingPDCAccounts],
	ISNULL([RemainingPDCs].[Amount], 0) AS [RemainingPDCAmount],
	ISNULL([RemainingPDCs].[ProjectedFee], 0) AS [RemainingPDCProjectedFee],
	ISNULL([RemainingPCCs].[Accounts], 0) AS [RemainingPCCAccounts],
	ISNULL([RemainingPCCs].[Amount], 0) AS [RemainingPCCAmount],
	ISNULL([RemainingPCCs].[ProjectedFee], 0) AS [RemainingPCCProjectedFee],
	ISNULL([Collected].[Accounts], 0) + ISNULL([RemainingPDCs].[Accounts], 0) + ISNULL([RemainingPCCs].[Accounts], 0) AS [ProjectedAccounts],
	ISNULL([Collected].[Amount], 0) + ISNULL([RemainingPDCs].[Amount], 0) + ISNULL([RemainingPCCs].[Amount], 0) AS [ProjectedAmount],
	ISNULL([Collected].[Fee], 0) + ISNULL([RemainingPDCs].[ProjectedFee], 0) + ISNULL([RemainingPCCs].[ProjectedFee], 0) AS [ProjectedFee]
FROM [desk]
INNER JOIN [Teams]
ON [desk].[TeamID] = [Teams].[ID]
INNER JOIN [Departments]
ON [Teams].[DepartmentID] = [Departments].[ID]
INNER JOIN [BranchCodes]
ON [Departments].[Branch] = [BranchCodes].[Code]
LEFT OUTER JOIN @WorkStats AS [WorkStats]
ON [desk].[code] = [WorkStats].[Desk]
LEFT OUTER JOIN @Promises AS [Promises]
ON [desk].[code] = [Promises].[Desk]
LEFT OUTER JOIN @PDCs AS [PDCs]
ON [desk].[code] = [PDCs].[Desk]
LEFT OUTER JOIN @PCCs AS [PCCs]
ON [desk].[code] = [PCCs].[Desk]
LEFT OUTER JOIN @Paid AS [Paid]
ON [desk].[code] = [Paid].[Desk]
LEFT OUTER JOIN @NSF AS [NSF]
ON [desk].[code] = [NSF].[Desk]
LEFT OUTER JOIN @Collected AS [Collected]
ON [desk].[code] = [Collected].[Desk]
LEFT OUTER JOIN @Reversed AS [Reversed]
ON [desk].[code] = [Reversed].[Desk]
LEFT OUTER JOIN @RemainingPDCs AS [RemainingPDCs]
ON [desk].[code] = [RemainingPDCs].[Desk]
LEFT OUTER JOIN @RemainingPCCs AS [RemainingPCCs]
ON [desk].[code] = [RemainingPCCs].[Desk]
ORDER BY [DeskCode];







GO
