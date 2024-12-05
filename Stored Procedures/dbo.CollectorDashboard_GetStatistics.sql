SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*EXEC CollectorDashboard_GetStatistics @userid=42*/
CREATE   PROCEDURE [dbo].[CollectorDashboard_GetStatistics]
@UserID INT
AS
SET NOCOUNT OFF;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @Today DATETIME;
DECLARE @BOM DATETIME;
DECLARE @EOM DATETIME;
DECLARE @DeskCode varchar(10)
SET @DeskCode=(SELECT DeskCode FROM Users WHERE ID=@UserID)

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
	[Branch] VARCHAR(5) NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[Touched] INTEGER NOT NULL,
	[Worked] INTEGER NOT NULL,
	[Contacted] INTEGER NOT NULL,
	[Attempts] INTEGER NOT NULL
);

DECLARE @Promises TABLE (
	[Branch] VARCHAR(5) NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL
);

DECLARE @PDCs TABLE (
	[Branch] VARCHAR(5) NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[ProjectedFee] MONEY NOT NULL
);

DECLARE @PCCs TABLE (
	[Branch] VARCHAR(5) NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[ProjectedFee] MONEY NOT NULL
);

DECLARE @Paid TABLE (
	[Branch] VARCHAR(5) NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[Fee] MONEY NOT NULL
);

DECLARE @NSF TABLE (
	[Branch] VARCHAR(5) NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[Fee] MONEY NOT NULL
);

DECLARE @Collected TABLE (
	[Branch] VARCHAR(5) NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[Fee] MONEY NOT NULL
);

DECLARE @Reversed TABLE (
	[Branch] VARCHAR(5) NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[Fee] MONEY NOT NULL
);

DECLARE @RemainingPDCs TABLE (
	[Branch] VARCHAR(5) NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[ProjectedFee] MONEY NOT NULL
);

DECLARE @RemainingPCCs TABLE (
	[Branch] VARCHAR(5) NOT NULL,
	[Desk] VARCHAR(10) NOT NULL,
	[Accounts] INTEGER NOT NULL,
	[Amount] MONEY NOT NULL,
	[ProjectedFee] MONEY NOT NULL
);

DECLARE @Departments TABLE (
	[Desk] VARCHAR(10) NOT NULL,
	[Code] VARCHAR(10) NULL,
	[Description] VARCHAR(50) NULL
);

INSERT INTO @WorkStats ([Branch], [Desk], [Touched], [Worked], [Contacted], [Attempts])
SELECT [desk].[branch] AS [Branch],
	[desk].[code] AS [DeskCode],
	ISNULL(SUM([DeskStats].[Touched]), 0) AS [Touched],
	ISNULL(SUM([DeskStats].[Worked]), 0) AS [Worked],
	ISNULL(SUM([DeskStats].[Contacted]), 0) AS [Contacted],
	ISNULL(SUM([DeskStats].[Attempts]), 0) AS [Attempts]
FROM [desk]
INNER JOIN [Users]
ON [desk].[code] = [Users].[DeskCode]
INNER JOIN [DeskStats]
ON [Users].[LoginName] = [DeskStats].[Desk]
WHERE [DeskStats].[TheDate] = @Today --AND [desk].[code]=@DeskCode
GROUP BY [desk].[branch],
	[desk].[code]
ORDER BY [Branch],
	[DeskCode];

INSERT INTO @Promises ([Branch], [Desk], [Accounts], [Amount])
SELECT [desk].[branch] AS [Branch],
	[desk].[code] AS [DeskCode],
	COUNT(DISTINCT [Promises].[AcctID]) AS [Accounts],
	ISNULL(SUM([Promises].[Amount]), 0) AS [Amount]
FROM [desk]
INNER JOIN [Promises]
ON [desk].[code] = [Promises].[Desk]
WHERE [Promises].[Entered] = @Today
AND [Promises].[Desk]= @DeskCode
AND [Promises].[DueDate] <= @EOM
AND [Promises].[Active] = 1
AND ([Promises].[Suspended] = 1
	OR [Promises].[Suspended] IS NULL)
GROUP BY [desk].[branch],
	[desk].[code];

INSERT INTO @PDCs ([Branch], [Desk], [Accounts], [Amount], [ProjectedFee])
SELECT [desk].[branch] AS [Branch],
	[desk].[code] AS [DeskCode],
	COUNT(DISTINCT [pdc].[number]) AS [Accounts],
	ISNULL(SUM([pdc].[amount]), 0) AS [Amount],
	ISNULL(SUM([pdc].[ProjectedFee]), 0) AS [ProjectedFee]
FROM [desk]
INNER JOIN [pdc]
ON [desk].[code] = [pdc].[desk]
WHERE [pdc].[entered] = @Today
AND [pdc].[desk] =  @DeskCode
AND [pdc].[deposit] <= @EOM
AND [pdc].[Active] = 1
GROUP BY [desk].[branch],
	[desk].[code];

INSERT INTO @PCCs ([Branch], [Desk], [Accounts], [Amount], [ProjectedFee])
SELECT [desk].[branch] AS [Branch],
	[desk].[code] AS [DeskCode],
	COUNT(DISTINCT [DebtorCreditCards].[number]) AS [Accounts],
	ISNULL(SUM([DebtorCreditCards].[amount]), 0) AS [Amount],
	ISNULL(SUM([DebtorCreditCards].[ProjectedFee]), 0) AS [ProjectedFee]
FROM [DebtorCreditCards]
INNER JOIN [master]
ON [DebtorCreditCards].[Number] = [master].[number]
INNER JOIN [desk]
ON [desk].[code] = [master].[desk]
WHERE [DebtorCreditCards].[DateEntered] = @Today
AND [master].[desk]= @DeskCode
AND [DebtorCreditCards].[DepositDate] <= @EOM
AND [DebtorCreditCards].[IsActive] = 1
GROUP BY [desk].[branch],
	[desk].[code];

INSERT INTO @Paid ([Branch], [Desk], [Accounts], [Amount], [Fee])
SELECT [desk].[branch] AS [Branch],
	[desk].[code] AS [DeskCode],
	COUNT(DISTINCT [payhistory].[number]) AS [Accounts],
	ISNULL(SUM([payhistory].[TotalPaid] - [payhistory].[OverPaidAmt]), 0) AS [Amount],
	ISNULL(SUM([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]), 0) AS [Fees]
FROM [desk]
INNER JOIN [payhistory]
ON [desk].[code] = [payhistory].[desk]
WHERE [payhistory].[datepaid] = @Today
AND [payhistory].[desk]= @DeskCode
AND [payhistory].[batchtype] IN ('PU', 'PC', 'PA')
GROUP BY [desk].[branch],
	[desk].[code];

INSERT INTO @NSF ([Branch], [Desk], [Accounts], [Amount], [Fee])
SELECT [desk].[branch] AS [Branch],
	[desk].[code] AS [DeskCode],
	COUNT(DISTINCT [payhistory].[number]) AS [Accounts],
	ISNULL(SUM([payhistory].[TotalPaid] - [payhistory].[OverPaidAmt]), 0) AS [Amount],
	ISNULL(SUM([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]), 0) AS [Fees]
FROM [desk]
INNER JOIN [payhistory]
ON [desk].[code] = [payhistory].[desk]
WHERE [payhistory].[datepaid] = @Today
AND [payhistory].[desk] = @DeskCode
AND [payhistory].[batchtype] IN ('PUR', 'PCR', 'PAR')
GROUP BY [desk].[branch],
	[desk].[code];

INSERT INTO @Collected ([Branch], [Desk], [Accounts], [Amount], [Fee])
SELECT [desk].[branch] AS [Branch],
	[desk].[code] AS [DeskCode],
	COUNT(DISTINCT [payhistory].[number]) AS [Accounts],
	ISNULL(SUM([payhistory].[TotalPaid] - [payhistory].[OverPaidAmt]), 0) AS [Amount],
	ISNULL(SUM([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]), 0) AS [Fees]
FROM [desk]
INNER JOIN [payhistory]
ON [desk].[code] = [payhistory].[desk]
WHERE [payhistory].[systemyear] = @SystemYear
AND [payhistory].[desk] = @DeskCode
AND [payhistory].[systemmonth] = @SystemMonth
AND [payhistory].[batchtype] IN ('PU', 'PC', 'PA')
GROUP BY [desk].[branch],
	[desk].[code];

INSERT INTO @Reversed ([Branch], [Desk], [Accounts], [Amount], [Fee])
SELECT [desk].[branch] AS [Branch],
	[desk].[code] AS [DeskCode],
	COUNT(DISTINCT [payhistory].[number]) AS [Accounts],
	ISNULL(SUM([payhistory].[TotalPaid] - [payhistory].[OverPaidAmt]), 0) AS [Amount],
	ISNULL(SUM([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]), 0) AS [Fees]
FROM [desk]
INNER JOIN [payhistory]
ON [desk].[code] = [payhistory].[desk]
WHERE [payhistory].[systemyear] = @SystemYear
AND [payhistory].[desk] = @DeskCode
AND [payhistory].[systemmonth] = @SystemMonth
AND [payhistory].[batchtype] IN ('PUR', 'PCR', 'PAR')
GROUP BY [desk].[branch],
	[desk].[code];

INSERT INTO @RemainingPDCs ([Branch], [Desk], [Accounts], [Amount], [ProjectedFee])
SELECT [desk].[branch] AS [Branch],
	[desk].[code] AS [DeskCode],
	COUNT(DISTINCT [pdc].[number]) AS [Accounts],
	ISNULL(SUM([pdc].[amount]), 0) AS [Amount],
	ISNULL(SUM([pdc].[ProjectedFee]), 0) AS [ProjectedFee]
FROM [desk]
INNER JOIN [master]
ON [desk].[code] = [master].[desk]
INNER JOIN [pdc]
ON [master].[number] = [pdc].[number]
WHERE [pdc].[deposit] <= @EOM
AND [master].[desk] = @DeskCode
AND [pdc].[Active] = 1
AND [pdc].[onhold] IS NULL
GROUP BY [desk].[branch],
	[desk].[code];

INSERT INTO @RemainingPCCs ([Branch], [Desk], [Accounts], [Amount], [ProjectedFee])
SELECT [desk].[branch] AS [Branch],
	[desk].[code] AS [DeskCode],
	COUNT(DISTINCT [DebtorCreditCards].[number]) AS [Accounts],
	ISNULL(SUM([DebtorCreditCards].[amount]), 0) AS [Amount],
	ISNULL(SUM([DebtorCreditCards].[ProjectedFee]), 0) AS [ProjectedFee]
FROM [desk]
INNER JOIN [master]
ON [desk].[code] = [master].[desk]
INNER JOIN [DebtorCreditCards] 
ON [master].[number] = [DebtorCreditCards].[number]
WHERE [DebtorCreditCards].[DepositDate] <= @EOM
AND [master].[desk] =  @DeskCode
AND [DebtorCreditCards].[IsActive] = 1
AND [DebtorCreditCards].[onholdDate] IS NULL
GROUP BY [desk].[branch],
	[desk].[code];

SELECT [desk].[code] AS [Desk_Code],
	[desk].[name] AS [Desk_Name],
	UPPER([desk].[desktype]) AS [Desk_Type],
	ISNULL([Departments].[Code], 'DEFAULT') AS [Department_Code],
	ISNULL([Departments].[Description], 'Default') AS [Department],
	[desk].[branch] AS [Branch],
	[BranchCodes].[Name] AS [Branch_Name],
	ISNULL([WorkStats].[Touched], 0) AS [Touched],
	ISNULL([WorkStats].[Worked], 0) AS [Worked],
	ISNULL([WorkStats].[Contacted], 0) AS [Contacted],
	ISNULL([WorkStats].[Attempts], 0) AS [Attempts],
	ISNULL([Promises].[Accounts], 0) AS [Promised_Accounts],
	ISNULL([Promises].[Amount], 0) AS [Promised_Amount],
	ISNULL([PDCs].[Accounts], 0) AS [PDC_Accounts],
	ISNULL([PDCs].[Amount], 0) AS [PDC_Amount],
	ISNULL([PDCs].[ProjectedFee], 0) AS [PDC_Projected_Fee],
	ISNULL([PCCs].[Accounts], 0) AS [PCC_Accounts],
	ISNULL([PCCs].[Amount], 0) AS [PCC_Amount],
	ISNULL([PCCs].[ProjectedFee], 0) AS [PCC_Projected_Fee],
	ISNULL([Paid].[Accounts], 0) AS [Paid_Accounts],
	ISNULL([Paid].[Amount], 0) AS [Paid_Amount],
	ISNULL([Paid].[Fee], 0) AS [Paid_Fee],
	ISNULL([NSF].[Accounts], 0) AS [NSF_Accounts],
	ISNULL([NSF].[Amount], 0) AS [NSF_Amount],
	ISNULL([NSF].[Fee], 0) AS [NSF_Fee],
	ISNULL([Collected].[Accounts], 0) AS [MTD_Paid_Accounts],
	ISNULL([Collected].[Amount], 0) AS [MTD_Paid_Amount],
	ISNULL([Collected].[Fee], 0) AS [MTD_Paid_Fee],
	ISNULL([Reversed].[Accounts], 0) AS [MTD_NSF_Accounts],
	ISNULL([Reversed].[Amount], 0) AS [MTD_NSF_Amount],
	ISNULL([Reversed].[Fee], 0) AS [MTD_NSF_Fee],
	ISNULL([Collected].[Accounts], 0) - ISNULL([Reversed].[Accounts], 0) AS [MTD_Collected_Accounts],
	ISNULL([Collected].[Amount], 0) - ISNULL([Reversed].[Amount], 0) AS [MTD_Collected_Amount],
	ISNULL([Collected].[Fee], 0) - ISNULL([Reversed].[Fee], 0) AS [MTD_Collected_Fee],
	ISNULL([RemainingPDCs].[Accounts], 0) AS [Remaining_PDC_Accounts],
	ISNULL([RemainingPDCs].[Amount], 0) AS [Remaining_PDC_Amount],
	ISNULL([RemainingPDCs].[ProjectedFee], 0) AS [Remaining_PDC_Projected_Fee],
	ISNULL([RemainingPCCs].[Accounts], 0) AS [Remaining_PCC_Accounts],
	ISNULL([RemainingPCCs].[Amount], 0) AS [Remaining_PCC_Amount],
	ISNULL([RemainingPCCs].[ProjectedFee], 0) AS [Remaining_PCC_Projected_Fee],
	ISNULL([Collected].[Accounts], 0) + ISNULL([RemainingPDCs].[Accounts], 0) + ISNULL([RemainingPCCs].[Accounts], 0) AS [Projected_Accounts],
	ISNULL([Collected].[Amount], 0) + ISNULL([RemainingPDCs].[Amount], 0) + ISNULL([RemainingPCCs].[Amount], 0) AS [Projected_Amount],
	ISNULL([Collected].[Fee], 0) + ISNULL([RemainingPDCs].[ProjectedFee], 0) + ISNULL([RemainingPCCs].[ProjectedFee], 0) AS [Projected_Fee],

	ISNULL([Collected].[Amount], 0) - ISNULL([Reversed].[Amount], 0) +		--mtd amount
		ISNULL([RemainingPDCs].[Amount], 0) +								--remaining PDC amount
		ISNULL([RemainingPCCs].[Amount], 0) as [MTD_Remaining_Amount],								--remaining PCC amount

	ISNULL([Collected].[Fee], 0) - ISNULL([Reversed].[Fee], 0) +				--mtd fee
		ISNULL([RemainingPDCs].[ProjectedFee], 0) +								--remaining pdc fee
		ISNULL([RemainingPCCs].[ProjectedFee], 0) as [MTD_Remaining_Fee]		--remaining pcc fee
FROM [desk]
INNER JOIN [BranchCodes]
ON [desk].[Branch] = [BranchCodes].[Code]
LEFT OUTER JOIN @Departments AS [Departments]
ON [desk].[code] = [Departments].[Desk]
LEFT OUTER JOIN @WorkStats AS [WorkStats]
ON [desk].[code] = [WorkStats].[Desk]
LEFT OUTER JOIN @Promises AS [Promises]
ON [desk].[code] = [Promises].[Desk]
LEFT OUTER JOIN @PDCs AS [PDCs]
ON [desk].[code] = [PDCs].[Desk]
LEFT OUTER JOIN @PDCs AS [PCCs]
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
WHERE [desk].[code] =  @DeskCode
ORDER BY [Desk_Code];
GO
