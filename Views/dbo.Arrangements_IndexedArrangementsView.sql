SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Arrangements_IndexedArrangementsView]
AS
WITH [Arrangements] AS (
	SELECT
		'PPA' AS [Type],
		[Promises].[ID],
		[Promises].[Entered] AS [EnteredDate],
		[Promises].[DueDate] AS [DueDate],
		[Promises].[AcctID] AS [AccountID],
		ROW_NUMBER() OVER (PARTITION BY [Promises].[ID] ORDER BY CASE [Promises].[AcctID] WHEN [PromiseDetails].[AccountID] THEN 0 ELSE 1 END, [PromiseDetails].[AccountID]) AS [AffectedIndex],
		COALESCE([PromiseDetails].[AccountID], [Promises].[AcctID]) AS [AffectedAccountID],
		[Promises].[Amount] AS [TotalAmount],
		COALESCE([PromiseDetails].[Amount], [Promises].[Amount]) AS [AffectedAmount],
		[PromiseDetails].[ProjectedCurrent] AS [ProjectedCurrent],
		[PromiseDetails].[ProjectedRemaining] AS [ProjectedRemaining],
		[PromiseDetails].[ProjectedFee] AS [ProjectedFee],
		[PromiseDetails].[ProjectedCollectorFee] AS [ProjectedCollectorFee],
		COALESCE([Promises].[Suspended], 0) AS [OnHold],
		[Promises].[CreatedBy] AS [CreatedBy],
		[Promises].[DateCreated] AS [DateCreated],
		[Promises].[DateUpdated] AS [DateUpdated]
	FROM [dbo].[Promises]
	LEFT OUTER JOIN [dbo].[PromiseDetails]
	ON [PromiseDetails].[PromiseID] = [Promises].[ID]
	WHERE [Promises].[Active] = 1
	UNION ALL
		SELECT
		'PDC' AS [Type],
		[pdc].[UID],
		[pdc].[entered] AS [EnteredDate],
		[pdc].[deposit] AS [DueDate],
		[pdc].[number] AS [AccountID],
		ROW_NUMBER() OVER (PARTITION BY [pdc].[UID] ORDER BY CASE [pdc].[number] WHEN [PdcDetails].[AccountID] THEN 0 ELSE 1 END, [PdcDetails].[AccountID]) AS [AffectedIndex],
		COALESCE([PdcDetails].[AccountID], [pdc].[number]) AS [AffectedAccountID],
		[pdc].[amount] AS [TotalAmount],
		COALESCE([PdcDetails].[Amount], [pdc].[amount]) AS [AffectedAmount],
		[PdcDetails].[ProjectedCurrent] AS [ProjectedCurrent],
		[PdcDetails].[ProjectedRemaining] AS [ProjectedRemaining],
		[PdcDetails].[ProjectedFee] AS [ProjectedFee],
		[PdcDetails].[ProjectedCollectorFee] AS [ProjectedCollectorFee],
		CASE
			WHEN [pdc].[onhold] IS NULL
			THEN 0
			ELSE 1
		END AS [OnHold],
		[pdc].[CreatedBy] AS [CreatedBy],
		[pdc].[DateCreated] AS [DateCreated],
		[pdc].[DateUpdated] AS [DateUpdated]
	FROM [dbo].[pdc]
	LEFT OUTER JOIN [dbo].[PdcDetails]
	ON [PdcDetails].[PdcID] = [pdc].[UID]
	WHERE [pdc].[Active] = 1
	UNION ALL
		SELECT
		'PCC' AS [Type],
		[DebtorCreditCards].[ID],
		[DebtorCreditCards].[DateEntered] AS [EnteredDate],
		[DebtorCreditCards].[DepositDate] AS [DueDate],
		[DebtorCreditCards].[Number] AS [AccountID],
		ROW_NUMBER() OVER (PARTITION BY [DebtorCreditCards].[ID] ORDER BY CASE [DebtorCreditCards].[number] WHEN [DebtorCreditCardDetails].[AccountID] THEN 0 ELSE 1 END, [DebtorCreditCardDetails].[AccountID]) AS [AffectedIndex],
		COALESCE([DebtorCreditCardDetails].[AccountID], [DebtorCreditCards].[number]) AS [AffectedAccountID],
		[DebtorCreditCards].[Amount] AS [TotalAmount],
		COALESCE([DebtorCreditCardDetails].[Amount], [DebtorCreditCards].[amount]) AS [AffectedAmount],
		[DebtorCreditCardDetails].[ProjectedCurrent] AS [ProjectedCurrent],
		[DebtorCreditCardDetails].[ProjectedRemaining] AS [ProjectedRemaining],
		[DebtorCreditCardDetails].[ProjectedFee] AS [ProjectedFee],
		[DebtorCreditCardDetails].[ProjectedCollectorFee] AS [ProjectedCollectorFee],
		CASE
			WHEN [DebtorCreditCards].[OnHoldDate] IS NULL
			THEN 0
			ELSE 1
		END AS [OnHold],
		[DebtorCreditCards].[CreatedBy] AS [CreatedBy],
		[DebtorCreditCards].[DateCreated] AS [DateCreated],
		[DebtorCreditCards].[DateUpdated] AS [DateUpdated]
	FROM [dbo].[DebtorCreditCards]
	LEFT OUTER JOIN [dbo].[DebtorCreditCardDetails]
	ON [DebtorCreditCardDetails].[DebtorCreditCardID] = [DebtorCreditCards].[ID]
	WHERE [DebtorCreditCards].[IsActive] = 1
), [IndexedArrangements] AS (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY [AffectedAccountID] ORDER BY [DueDate]) AS [Index],
		[Type],
		[ID],
		[EnteredDate],
		[DueDate],
		[AccountID],
		[AffectedIndex],
		[AffectedAccountID],
		[TotalAmount],
		[AffectedAmount],
		[ProjectedCurrent],
		[ProjectedRemaining],
		[ProjectedFee],
		[ProjectedCollectorFee],
		[CreatedBy],
		[DateCreated],
		[DateUpdated]
	FROM [Arrangements]
)
SELECT [AffectedAccountID],
	[Index],
	[Type],
	[ID],
	[EnteredDate],
	[DueDate],
	[AccountID],
	[AffectedIndex],
	[TotalAmount],
	[AffectedAmount],
	[ProjectedCurrent],
	[ProjectedRemaining],
	[ProjectedFee],
	[ProjectedCollectorFee],
	[CreatedBy],
	[DateCreated],
	[DateUpdated]
FROM [IndexedArrangements];

GO
