SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_GetArrangement] @ID INTEGER
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @AccountIDs TABLE (
		[AccountID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	DECLARE @PromiseIDs TABLE (
		[PromiseID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	DECLARE @PdcIDs TABLE (
		[PdcID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	DECLARE @PccIDs TABLE (
		[PccID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	INSERT INTO @PromiseIDs([PromiseId])
	SELECT [Promises].[ID]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[Promises]
		ON [Promises].[ArrangementID] = [Arrangements].[ID]
	WHERE [Arrangements].[ID] = @ID 
	AND [Promises].[Active] = 1;

	INSERT INTO @PdcIDs([PdcID])
	SELECT [pdc].[UID]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[pdc]
		ON [pdc].[ArrangementId] = [Arrangements].[ID]
	--INNER JOIN [dbo].[PdcBankRelationshipView]
	--	ON [pdc].[UID] = [PdcBankRelationshipView].[PdcID]
	--LEFT JOIN [dbo].[DebtorBankInfo]
	--	ON [PdcBankRelationshipView].[DebtorBankID] = [DebtorBankInfo].[BankID]
	LEFT OUTER JOIN [dbo].[PaymentSurchargeOverride]
		ON [pdc].[UID] = [PaymentSurchargeOverride].[PaymentId]
		AND [PaymentSurchargeOverride].[PaymentTableId] = 1
	WHERE [Arrangements].[ID] = @ID
	AND [pdc].[active] = 1;
	
	INSERT INTO @PdcIDs ([PdcID])
	SELECT [pdc].[UID]
	FROM [dbo].[pdc]
	WHERE [pdc].[ArrangementId] = @ID
	AND [pdc].[active] = 0
	AND [pdc].[NSFCount] = 1;

	INSERT INTO @PccIDs([PccId])
	SELECT  [DebtorCreditCards].[ID]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[DebtorCreditCards]
		ON [DebtorCreditCards].[ArrangementId] = [Arrangements].[ID]
	LEFT OUTER JOIN [dbo].[imagefiles]
		ON [DebtorCreditCards].[CCImageID] = [imagefiles].[id]
	LEFT OUTER JOIN [dbo].[PaymentSurchargeOverride]
		ON [DebtorCreditCards].[ID] = [PaymentSurchargeOverride].[PaymentId]
	AND [PaymentSurchargeOverride].[PaymentTableId] = 2
	WHERE [Arrangements].[ID] = @ID
	AND [DebtorCreditCards].[IsActive] = 1;

	INSERT INTO @PccIDs ([PccID])
	SELECT [DebtorCreditCards].[ID]
	FROM [dbo].[DebtorCreditCards]
	WHERE [DebtorCreditCards].[ArrangementId] = @ID
	AND [DebtorCreditCards].[IsActive] = 0
	AND (([DebtorCreditCards].[AuthErrCode] = 1 AND [NSFCount] >= 0) OR [NSFCount] = 1);	

	
	INSERT INTO @AccountIDs([AccountId])
	SELECT DISTINCT [number] FROM [dbo].[master]
	WHERE [number] IN (
	
		SELECT [Promises].[AcctId]
		FROM @PromiseIDS AS [P]
		INNER JOIN [dbo].[Promises]
			ON [Promises].[ID] = [P].[PromiseID]
		
		UNION ALL 
		
		SELECT [PromiseDetails].[AccountID]
		FROM @PromiseIDS AS [P]
		INNER JOIN [dbo].[Promises]
			ON [Promises].[ID] = [P].[PromiseID]
		INNER JOIN [dbo].[PromiseDetails] 
			ON [Promises].[ID] = [PromiseDetails] .[PromiseID]

		UNION ALL 
		
		SELECT [Pdc].[number]
		FROM @PdcIDS AS [P]
		INNER JOIN [dbo].[Pdc]
			ON [Pdc].[UID] = [P].[PdcID]
		
		UNION ALL 
		
		SELECT [PdcDetails].[AccountID]
		FROM @PdcIDS AS [P]
		INNER JOIN [dbo].[Pdc]
			ON [Pdc].[UID] = [P].[PdcID]
		INNER JOIN [dbo].[PdcDetails] 
			ON [Pdc].[UID] = [PdcDetails].[PdcID]
			
		UNION ALL 
		
		SELECT [DebtorCreditCards].[number]
		FROM @PccIDS AS [P]
		INNER JOIN [dbo].[DebtorCreditCards]
			ON [DebtorCreditCards].[ID] = [P].[PccID]
		
		UNION ALL 
		
		SELECT [DebtorCreditCardDetails].[AccountID]
		FROM @PccIDS AS [P]
		INNER JOIN [dbo].[DebtorCreditCards]
			ON [DebtorCreditCards].[ID] = [P].[PccID]
		INNER JOIN [dbo].[DebtorCreditCardDetails]
			ON [DebtorCreditCards].[ID] = [DebtorCreditCardDetails].[DebtorCreditCardID]		
	);

	--SELECT * FROM @PromiseIDs;
	--SELECT * FROM @PdcIDs;
	--SELECT * FROM @PccIDs;
	SELECT [AccountId] FROM @AccountIDS;
	
	SELECT [Promises].[ID],
		[Promises].[Entered],
		[Promises].[DueDate],
		[Promises].[AcctID],
		[Promises].[DebtorID],
		[Promises].[Amount],
		[Promises].[Desk],
		[Promises].[Customer],
		[Promises].[SendRM],
		[Promises].[LetterCode],
		[Promises].[SendRMDate],
		[Promises].[RMSentDate],
		[Promises].[ApprovedBy],
		[Promises].[Suspended],
		[Promises].[PaymentLinkUID],
		[Arrangements].[ID] AS [ArrangementID],
		[Arrangements].[SpreadAlgorithm],
		CAST(NULL AS INTEGER) AS [SurchargeTypeId],
		[Arrangements].[FlatSurcharge],
		[Arrangements].[PercentageSurcharge],
		[Arrangements].[AddedFlatSurcharge],
		[Arrangements].[AddedPercentageSurcharge],
		[Arrangements].[ManualSurcharge],
		[Arrangements].[ArrangementFee],
		ISNULL([Arrangements].[ReviewFlag],'') AS [ReviewFlag]

	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[Promises]
		ON [Promises].[ArrangementID] = [Arrangements].[ID]
	WHERE [Arrangements].[ID] = @ID 
	AND [Promises].[Active] = 1;

	SELECT [PromiseDetails].[PromiseID],
		[PromiseDetails].[AccountID],
		[PromiseDetails].[Amount],
		CAST(0 AS MONEY) AS [Surcharge],
		[PromiseDetails].[Settlement],
		[PromiseDetails].[ProjectedCurrent],
		[PromiseDetails].[ProjectedRemaining],
		[PromiseDetails].[ProjectedFee],
		[PromiseDetails].[ProjectedCollectorFee]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[Promises]
		ON [Promises].[ArrangementID] = [Arrangements].[ID]
	INNER JOIN [dbo].[PromiseDetails]
		ON [PromiseDetails].[PromiseID] = [Promises].[ID]
	WHERE [Arrangements].[ID] = @ID
	AND [Promises].[Active] = 1;

	SELECT [pdc].[UID],
		[pdc].[number],
		[pdc].[PDC_Type],
		[pdc].[entered],
		[pdc].[onhold],
		[pdc].[deposit],
		[pdc].[amount] + COALESCE([pdc].[SurCharge], 0) AS [amount],
		[pdc].[checknbr],
		[pdc].[SEQ],
		[pdc].[Desk],
		[pdc].[customer],
		[pdc].[nitd],
		[pdc].[LtrCode],
		[pdc].[SurCharge],
		[pdc].[Printed],
		ISNULL([pdc].[IsExternallyManaged], 0) AS [IsExternallyManaged],
		--(SELECT [pvsp1].[Status] FROM [PaymentVendorSeriesPayment] [pvsp1] inner join (SELECT max([Id]) [max_id] FROM [PaymentVendorSeriesPayment] [pvsp_sel] where [pvsp_sel].[PdcId] = [Pdc].[UID]) [pvsp_max] on [pvsp_max].[max_id] = [pvsp1].[id]) as [RecentPVGSeriesStatus],
		(SELECT [pvs2].[SeriesSource] FROM [PaymentVendorSeriesPayment] [pvsp2] inner join (SELECT max([Id]) [max_id] FROM [PaymentVendorSeriesPayment] [pvsp2_sel] where [pvsp2_sel].[PdcId] = [Pdc].[UID]) [pvsp2_max] on [pvsp2_max].[max_id] = [pvsp2].[id] inner join [PaymentVendorSeries] [pvs2] on pvs2.id = pvsp2.paymentvendorseriesid) as [ExternalSeriesSource],
		[pdc].[IsBatched],
		[pdc].[ApprovedBy],
		[pdc].[PromiseMode],
		[pdc].[ProjectedFee],
		[pdc].[UseProjectedFee],
		[pdc].[CollectorFee],
		[pdc].[SurchargeCheckNbr],
		[pdc].[DepositToGeneralTrust],	
		--[pdc].[DebtorBankID],
		[pdc].[PaymentLinkUID],
		[pdc].[NSFCount],
		[pdc].[DateUpdated],
		--[DebtorBankInfo].[BankID],
		--[DebtorBankInfo].[AccountNumber],
		--[DebtorBankInfo].[AccountName],
		--[DebtorBankInfo].[AccountAddress1],
		--[DebtorBankInfo].[AccountAddress2],
		--[DebtorBankInfo].[AccountCity],
		--[DebtorBankInfo].[AccountState],
		--[DebtorBankInfo].[AccountZipcode],
		--[DebtorBankInfo].[AccountVerified],
		--[DebtorBankInfo].[LastCheckNumber],
		--[DebtorBankInfo].[AccountType],
		--[DebtorBankInfo].[ABANumber],
		--[DebtorBankInfo].[BankName],
		--[DebtorBankInfo].[BankAddress],
		--[DebtorBankInfo].[BankCity],
		--[DebtorBankInfo].[BankState],
		--[DebtorBankInfo].[BankZipcode],
		--[DebtorBankInfo].[BankPhone],
		[Arrangements].[ID] AS [ArrangementID],
		[Arrangements].[SpreadAlgorithm],
		[PaymentSurchargeOverride].[SurchargeTypeId],
		[Arrangements].[FlatSurcharge],
		[Arrangements].[PercentageSurcharge],
		[Arrangements].[AddedFlatSurcharge],
		[Arrangements].[AddedPercentageSurcharge],
		[Arrangements].[ManualSurcharge],
		ISNULL([Arrangements].[ReviewFlag],'') AS [ReviewFlag],
		[pdc].[PaymentVendorTokenId],
		--ISNULL( [pdc].[PaymentVendorTokenId], [DebtorBankInfo].[PaymentVendorTokenId] ) AS PaymentVendorTokenId,
		[Arrangements].[ArrangementFee]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[pdc]
		ON [pdc].[ArrangementId] = [Arrangements].[ID]
	--INNER JOIN [dbo].[PdcBankRelationshipView]
	--	ON [pdc].[UID] = [PdcBankRelationshipView].[PdcID]
	--LEFT JOIN [dbo].[DebtorBankInfo]
	--	ON [PdcBankRelationshipView].[DebtorBankID] = [DebtorBankInfo].[BankID]
	LEFT OUTER JOIN [dbo].[PaymentSurchargeOverride]
		ON [pdc].[UID] = [PaymentSurchargeOverride].[PaymentId]
		AND [PaymentSurchargeOverride].[PaymentTableId] = 1
	WHERE [Arrangements].[ID] = @ID
	AND [pdc].[active] = 1;

	SELECT [PdcDetails].[PdcID],
		[PdcDetails].[AccountID],
		[PdcDetails].[Amount],
		[PdcDetails].[Surcharge],
		[PdcDetails].[Settlement],
		[PdcDetails].[ProjectedCurrent],
		[PdcDetails].[ProjectedRemaining],
		[PdcDetails].[ProjectedFee],
		[PdcDetails].[ProjectedCollectorFee]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[pdc]
		ON [pdc].[ArrangementId] = [Arrangements].[ID]
	INNER JOIN [dbo].[PdcDetails]
		ON  [PdcDetails].[PdcID] = [pdc].[UID]
	WHERE [Arrangements].[ID] = @ID
	AND [pdc].[active] = 1;

	SELECT  [DebtorCreditCards].[ID],
		[DebtorCreditCards].[Number],
		--[DebtorCreditCards].[Name],
		--[DebtorCreditCards].[Street1],
		--[DebtorCreditCards].[Street2],
		--[DebtorCreditCards].[City],
		--[DebtorCreditCards].[State],
		--[DebtorCreditCards].[Zipcode],
		--[DebtorCreditCards].[CardNumber],
		--[DebtorCreditCards].[EXPMonth],
		--[DebtorCreditCards].[EXPYear],
		--[DebtorCreditCards].[CreditCard],
		[DebtorCreditCards].[Amount] + COALESCE([DebtorCreditCards].[Surcharge], 0) AS [Amount],
		[DebtorCreditCards].[Printed],
		ISNULL([DebtorCreditCards].[IsExternallyManaged], 0) AS [IsExternallyManaged],
		--(SELECT [pvsp1].[Status] FROM [PaymentVendorSeriesPayment] [pvsp1] inner join (SELECT max([Id]) [max_id] FROM [PaymentVendorSeriesPayment] [pvsp_sel] where [pvsp_sel].[DebtorCreditCardId] = [DebtorCreditCards].[ID]) [pvsp_max] on [pvsp_max].[max_id] = [pvsp1].[id]) as [RecentPVGSeriesStatus],
		  (SELECT [pvs2].[SeriesSource] FROM [PaymentVendorSeriesPayment] [pvsp2] inner join (SELECT max([Id]) [max_id] FROM [PaymentVendorSeriesPayment] [pvsp2_sel] where [pvsp2_sel].[DebtorCreditCardId] = [DebtorCreditCards].[ID]) [pvsp2_max] on [pvsp2_max].[max_id] = [pvsp2].[id] inner join [PaymentVendorSeries] [pvs2] on pvs2.id = pvsp2.paymentvendorseriesid) as [ExternalSeriesSource],
		[DebtorCreditCards].[IsBatched],
		[DebtorCreditCards].[ApprovedBy],
		[DebtorCreditCards].[Code],
		[DebtorCreditCards].[CollectorFee],
		[DebtorCreditCards].[DebtorID],
		[DebtorCreditCards].[DateEntered],
		[DebtorCreditCards].[DepositDate],
		[DebtorCreditCards].[NITDSentDate],
		[DebtorCreditCards].[LetterCode],
		[DebtorCreditCards].[NITDSendDate],
		[DebtorCreditCards].[OnHoldDate],
		[DebtorCreditCards].[ProjectedFee],
		[DebtorCreditCards].[UseProjectedFee],
		[DebtorCreditCards].[Surcharge],
		[DebtorCreditCards].[PromiseMode],
		[DebtorCreditCards].[DepositToGeneralTrust],
		[DebtorCreditCards].[DepositSurchargeToOperatingTrust],
		--[DebtorCreditCards].[CCImageID],
		[DebtorCreditCards].[PaymentLinkUID],
		[DebtorCreditCards].[AuthErrCode],
		[DebtorCreditCards].[NSFCount],
		[DebtorCreditCards].[DateUpdated],
		[imagefiles].[data] AS [CCData],
		[Arrangements].[ID] AS [ArrangementID],
		[Arrangements].[SpreadAlgorithm],
		[PaymentSurchargeOverride].[SurchargeTypeId],
		[Arrangements].[FlatSurcharge],
		[Arrangements].[PercentageSurcharge],
		[Arrangements].[AddedFlatSurcharge],
		[Arrangements].[AddedPercentageSurcharge],
		[Arrangements].[ManualSurcharge],
		[DebtorCreditCards].[PaymentVendorTokenId],
		ISNULL([Arrangements].[ReviewFlag],'') AS [ReviewFlag],
		[Arrangements].[ArrangementFee]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[DebtorCreditCards]
		ON [DebtorCreditCards].[ArrangementId] = [Arrangements].[ID]
	LEFT OUTER JOIN [dbo].[imagefiles]
		ON [DebtorCreditCards].[CCImageID] = [imagefiles].[id]
	LEFT OUTER JOIN [dbo].[PaymentSurchargeOverride]
		ON [DebtorCreditCards].[ID] = [PaymentSurchargeOverride].[PaymentId]
	AND [PaymentSurchargeOverride].[PaymentTableId] = 2
	WHERE [Arrangements].[ID] = @ID
	AND [DebtorCreditCards].[IsActive] = 1;

	SELECT [DebtorCreditCardDetails].[DebtorCreditCardID],
		[DebtorCreditCardDetails].[AccountID],
		[DebtorCreditCardDetails].[Amount],
		[DebtorCreditCardDetails].[Surcharge],
		[DebtorCreditCardDetails].[Settlement],
		[DebtorCreditCardDetails].[ProjectedCurrent],
		[DebtorCreditCardDetails].[ProjectedRemaining],
		[DebtorCreditCardDetails].[ProjectedFee],
		[DebtorCreditCardDetails].[ProjectedCollectorFee]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[DebtorCreditCards]
		ON [DebtorCreditCards].[ArrangementId] = [Arrangements].[ID]
	INNER JOIN [dbo].[DebtorCreditCardDetails]
		ON [DebtorCreditCardDetails].[DebtorCreditCardID] = [DebtorCreditCards].[ID] 
	WHERE [Arrangements].[ID] = @ID
	AND [DebtorCreditCards].[IsActive] = 1;

	SELECT [Settlement].[ID],
		[Settlement].[AccountID],
		[Settlement].[SettlementTotalAmount],
		[Settlement].[ExpirationDays],
		[Settlement].[CreatedBy],
		[Settlement].[Created],
		[Settlement].[Updated],
		[Settlement].[SettlementAmount]
	FROM [dbo].[master]
	INNER JOIN [dbo].[Settlement]
	ON [master].[number] = [Settlement].[AccountID]
	AND [master].[SettlementID] = [Settlement].[ID]
	WHERE [master].[number] IN 
	(
		SELECT DISTINCT [Promises].[AcctId]
		FROM [dbo].[Arrangements]
		INNER JOIN [dbo].[Promises]
			ON [Promises].[ArrangementID] = [Arrangements].[ID]
		WHERE [Arrangements].[ID] = @ID 
		AND [Promises].[Active] = 1

		UNION ALL 
		
		SELECT DISTINCT [PromiseDetails].[AccountID]
		FROM [dbo].[Arrangements]
		INNER JOIN [dbo].[Promises]
			ON [Promises].[ArrangementID] = [Arrangements].[ID]
		INNER JOIN [dbo].[PromiseDetails]
			ON [PromiseDetails].[PromiseID] = [Promises].[ID]
		WHERE [Arrangements].[ID] = @ID
		AND [Promises].[Active] = 1

		UNION ALL 
				
		SELECT DISTINCT [pdc].[Number]
		FROM [dbo].[Arrangements]
		INNER JOIN [dbo].[pdc]
			ON [pdc].[ArrangementId] = [Arrangements].[ID]
		INNER JOIN [dbo].[PdcBankRelationshipView]
			ON [pdc].[UID] = [PdcBankRelationshipView].[PdcID]
		WHERE [Arrangements].[ID] = @ID
		AND [pdc].[active] = 1

		UNION ALL 
		
		SELECT DISTINCT [PdcDetails].[AccountID]
		FROM [dbo].[Arrangements]
		INNER JOIN [dbo].[pdc]
			ON [pdc].[ArrangementId] = [Arrangements].[ID]
		INNER JOIN [dbo].[PdcDetails]
			ON  [PdcDetails].[PdcID] = [pdc].[UID]
		WHERE [Arrangements].[ID] = @ID
		AND [pdc].[active] = 1
		
		UNION ALL
		
		SELECT DISTINCT [DebtorCreditCards].[Number]
		FROM [dbo].[Arrangements]
		INNER JOIN [dbo].[DebtorCreditCards]
			ON [DebtorCreditCards].[ArrangementId] = [Arrangements].[ID]
		WHERE [Arrangements].[ID] = @ID
		AND [DebtorCreditCards].[IsActive] = 1

		UNION ALL
		
		SELECT DISTINCT [DebtorCreditCardDetails].[AccountID]
		FROM [dbo].[Arrangements]
		INNER JOIN [dbo].[DebtorCreditCards]
			ON [DebtorCreditCards].[ArrangementId] = [Arrangements].[ID]
		INNER JOIN [dbo].[DebtorCreditCardDetails]
			ON [DebtorCreditCardDetails].[DebtorCreditCardID] = [DebtorCreditCards].[ID] 
		WHERE [Arrangements].[ID] = @ID
		AND [DebtorCreditCards].[IsActive] = 1
	);
	
	--- Added by KAR on 08/15/2018 Handle NSF that are candidates for makeups...Enforce a Promse Read resulting in now rows due to the way the data manager works for payments.
	SELECT TOP 0 [Promises].[ID],
		[Promises].[Entered],
		[Promises].[DueDate],
		[Promises].[AcctID],
		[Promises].[DebtorID],
		[Promises].[Amount],
		[Promises].[Desk],
		[Promises].[Customer],
		[Promises].[SendRM],
		[Promises].[LetterCode],
		[Promises].[SendRMDate],
		[Promises].[RMSentDate],
		[Promises].[ApprovedBy],
		[Promises].[Suspended],
		[Promises].[PaymentLinkUID],
		[Arrangements].[ID] AS [ArrangementID],
		[Arrangements].[SpreadAlgorithm],
		CAST(NULL AS INTEGER) AS [SurchargeTypeId],
		[Arrangements].[FlatSurcharge],
		[Arrangements].[PercentageSurcharge],
		[Arrangements].[AddedFlatSurcharge],
		[Arrangements].[AddedPercentageSurcharge],
		[Arrangements].[ManualSurcharge],
		[Arrangements].[ReviewFlag],
		[Arrangements].[ArrangementFee]

	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[Promises]
		ON [Promises].[ArrangementID] = [Arrangements].[ID]
	WHERE [Arrangements].[ID] = @ID 
	AND [Promises].[Active] = 1;

	SELECT TOP 0 [PromiseDetails].[PromiseID],
		[PromiseDetails].[AccountID],
		[PromiseDetails].[Amount],
		CAST(0 AS MONEY) AS [Surcharge],
		[PromiseDetails].[Settlement],
		[PromiseDetails].[ProjectedCurrent],
		[PromiseDetails].[ProjectedRemaining],
		[PromiseDetails].[ProjectedFee],
		[PromiseDetails].[ProjectedCollectorFee]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[Promises]
		ON [Promises].[ArrangementID] = [Arrangements].[ID]
	INNER JOIN [dbo].[PromiseDetails]
		ON [PromiseDetails].[PromiseID] = [Promises].[ID]
	WHERE [Arrangements].[ID] = @ID
	AND [Promises].[Active] = 1;

	SELECT [pdc].[UID],
		[pdc].[number],
		[pdc].[PDC_Type],
		[pdc].[entered],
		[pdc].[onhold],
		[pdc].[deposit],
		[pdc].[amount] + COALESCE([pdc].[SurCharge], 0) AS [amount],
		[pdc].[checknbr],
		[pdc].[SEQ],
		[pdc].[Desk],
		[pdc].[customer],
		[pdc].[nitd],
		[pdc].[LtrCode],
		[pdc].[SurCharge],
		[pdc].[Printed],
		ISNULL([pdc].[IsExternallyManaged], 0) AS [IsExternallyManaged],
		--(SELECT [pvsp1].[Status] FROM [PaymentVendorSeriesPayment] [pvsp1] inner join (SELECT max([Id]) [max_id] FROM [PaymentVendorSeriesPayment] [pvsp_sel] where [pvsp_sel].[PdcId] = [Pdc].[UID]) [pvsp_max] on [pvsp_max].[max_id] = [pvsp1].[id]) as [RecentPVGSeriesStatus],
		(SELECT [pvs2].[SeriesSource] FROM [PaymentVendorSeriesPayment] [pvsp2] inner join (SELECT max([Id]) [max_id] FROM [PaymentVendorSeriesPayment] [pvsp2_sel] where [pvsp2_sel].[PdcId] = [Pdc].[UID]) [pvsp2_max] on [pvsp2_max].[max_id] = [pvsp2].[id] inner join [PaymentVendorSeries] [pvs2] on pvs2.id = pvsp2.paymentvendorseriesid) as [ExternalSeriesSource],
		[pdc].[IsBatched],
		[pdc].[ApprovedBy],
		[pdc].[PromiseMode],
		[pdc].[ProjectedFee],
		[pdc].[UseProjectedFee],
		[pdc].[CollectorFee],
		[pdc].[SurchargeCheckNbr],
		[pdc].[DepositToGeneralTrust],	
		--[pdc].[DebtorBankID],
		[pdc].[PaymentLinkUID],
		[pdc].[NSFCount],
		[pdc].[DateUpdated],
		--[DebtorBankInfo].[BankID],
		--[DebtorBankInfo].[AccountNumber],
		--[DebtorBankInfo].[AccountName],
		--[DebtorBankInfo].[AccountAddress1],
		--[DebtorBankInfo].[AccountAddress2],
		--[DebtorBankInfo].[AccountCity],
		--[DebtorBankInfo].[AccountState],
		--[DebtorBankInfo].[AccountZipcode],
		--[DebtorBankInfo].[AccountVerified],
		--[DebtorBankInfo].[LastCheckNumber],
		--[DebtorBankInfo].[AccountType],
		--[DebtorBankInfo].[ABANumber],
		--[DebtorBankInfo].[BankName],
		--[DebtorBankInfo].[BankAddress],
		--[DebtorBankInfo].[BankCity],
		--[DebtorBankInfo].[BankState],
		--[DebtorBankInfo].[BankZipcode],
		--[DebtorBankInfo].[BankPhone],
		[Arrangements].[ID] AS [ArrangementID],
		[Arrangements].[SpreadAlgorithm],
		[PaymentSurchargeOverride].[SurchargeTypeId],
		[Arrangements].[FlatSurcharge],
		[Arrangements].[PercentageSurcharge],
		[Arrangements].[AddedFlatSurcharge],
		[Arrangements].[AddedPercentageSurcharge],
		[Arrangements].[ManualSurcharge],
		[Arrangements].[ReviewFlag],
		[pdc].[PaymentVendorTokenId],
		--ISNULL( [pdc].[PaymentVendorTokenId], [DebtorBankInfo].[PaymentVendorTokenId] ) AS PaymentVendorTokenId,
		[Arrangements].[ArrangementFee]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[pdc]
		ON [pdc].[ArrangementId] = [Arrangements].[ID]
	--INNER JOIN [dbo].[PdcBankRelationshipView]
	--	ON [pdc].[UID] = [PdcBankRelationshipView].[PdcID]
	--LEFT JOIN [dbo].[DebtorBankInfo]
	--	ON [PdcBankRelationshipView].[DebtorBankID] = [DebtorBankInfo].[BankID]
	LEFT OUTER JOIN [dbo].[PaymentSurchargeOverride]
		ON [pdc].[UID] = [PaymentSurchargeOverride].[PaymentId]
		AND [PaymentSurchargeOverride].[PaymentTableId] = 1
	WHERE [Arrangements].[ID] = @ID
	AND [pdc].[active] = 0 AND [pdc].[NSFCount] = 1;

	SELECT [PdcDetails].[PdcID],
		[PdcDetails].[AccountID],
		[PdcDetails].[Amount],
		[PdcDetails].[Surcharge],
		[PdcDetails].[Settlement],
		[PdcDetails].[ProjectedCurrent],
		[PdcDetails].[ProjectedRemaining],
		[PdcDetails].[ProjectedFee],
		[PdcDetails].[ProjectedCollectorFee]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[pdc]
		ON [pdc].[ArrangementId] = [Arrangements].[ID]
	INNER JOIN [dbo].[PdcDetails]
		ON  [PdcDetails].[PdcID] = [pdc].[UID]
	WHERE [Arrangements].[ID] = @ID
	AND [pdc].[active] = 0 AND [pdc].[NSFCount] = 1;

	SELECT  [DebtorCreditCards].[ID],
		[DebtorCreditCards].[Number],
		--[DebtorCreditCards].[Name],
		--[DebtorCreditCards].[Street1],
		--[DebtorCreditCards].[Street2],
		--[DebtorCreditCards].[City],
		--[DebtorCreditCards].[State],
		--[DebtorCreditCards].[Zipcode],
		--[DebtorCreditCards].[CardNumber],
		--[DebtorCreditCards].[EXPMonth],
		--[DebtorCreditCards].[EXPYear],
		--[DebtorCreditCards].[CreditCard],
		[DebtorCreditCards].[Amount] + COALESCE([DebtorCreditCards].[Surcharge], 0) AS [Amount],
		[DebtorCreditCards].[Printed],
		ISNULL([DebtorCreditCards].[IsExternallyManaged], 0) AS [IsExternallyManaged],
		--(SELECT [pvsp1].[Status] FROM [PaymentVendorSeriesPayment] [pvsp1] inner join (SELECT max([Id]) [max_id] FROM [PaymentVendorSeriesPayment] [pvsp_sel] where [pvsp_sel].[DebtorCreditCardId] = [DebtorCreditCards].[ID]) [pvsp_max] on [pvsp_max].[max_id] = [pvsp1].[id]) as [RecentPVGSeriesStatus],
		  (SELECT [pvs2].[SeriesSource] FROM [PaymentVendorSeriesPayment] [pvsp2] inner join (SELECT max([Id]) [max_id] FROM [PaymentVendorSeriesPayment] [pvsp2_sel] where [pvsp2_sel].[DebtorCreditCardId] = [DebtorCreditCards].[ID]) [pvsp2_max] on [pvsp2_max].[max_id] = [pvsp2].[id] inner join [PaymentVendorSeries] [pvs2] on pvs2.id = pvsp2.paymentvendorseriesid) as [ExternalSeriesSource],
		[DebtorCreditCards].[IsBatched],
		[DebtorCreditCards].[ApprovedBy],
		[DebtorCreditCards].[Code],
		[DebtorCreditCards].[CollectorFee],
		[DebtorCreditCards].[DebtorID],
		[DebtorCreditCards].[DateEntered],
		[DebtorCreditCards].[DepositDate],
		[DebtorCreditCards].[NITDSentDate],
		[DebtorCreditCards].[LetterCode],
		[DebtorCreditCards].[NITDSendDate],
		[DebtorCreditCards].[OnHoldDate],
		[DebtorCreditCards].[ProjectedFee],
		[DebtorCreditCards].[UseProjectedFee],
		[DebtorCreditCards].[Surcharge],
		[DebtorCreditCards].[PromiseMode],
		[DebtorCreditCards].[DepositToGeneralTrust],
		[DebtorCreditCards].[DepositSurchargeToOperatingTrust],
		--[DebtorCreditCards].[CCImageID],
		[DebtorCreditCards].[PaymentLinkUID],
		[DebtorCreditCards].[AuthErrCode],
		[DebtorCreditCards].[NSFCount],
		[DebtorCreditCards].[DateUpdated],
		[imagefiles].[data] AS [CCData],
		[Arrangements].[ID] AS [ArrangementID],
		[Arrangements].[SpreadAlgorithm],
		[PaymentSurchargeOverride].[SurchargeTypeId],
		[Arrangements].[FlatSurcharge],
		[Arrangements].[PercentageSurcharge],
		[Arrangements].[AddedFlatSurcharge],
		[Arrangements].[AddedPercentageSurcharge],
		[Arrangements].[ManualSurcharge],
		[Arrangements].[ReviewFlag],
		[DebtorCreditCards].[PaymentVendorTokenId],
		[Arrangements].[ArrangementFee]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[DebtorCreditCards]
		ON [DebtorCreditCards].[ArrangementId] = [Arrangements].[ID]
	LEFT OUTER JOIN [dbo].[imagefiles]
		ON [DebtorCreditCards].[CCImageID] = [imagefiles].[id]
	LEFT OUTER JOIN [dbo].[PaymentSurchargeOverride]
		ON [DebtorCreditCards].[ID] = [PaymentSurchargeOverride].[PaymentId]
	AND [PaymentSurchargeOverride].[PaymentTableId] = 2
	WHERE [Arrangements].[ID] = @ID
	AND [DebtorCreditCards].[IsActive] = 0
	AND (([DebtorCreditCards].[AuthErrCode] = 1 AND [NSFCount] >= 0) OR [NSFCount] = 1);

	SELECT [DebtorCreditCardDetails].[DebtorCreditCardID],
		[DebtorCreditCardDetails].[AccountID],
		[DebtorCreditCardDetails].[Amount],
		[DebtorCreditCardDetails].[Surcharge],
		[DebtorCreditCardDetails].[Settlement],
		[DebtorCreditCardDetails].[ProjectedCurrent],
		[DebtorCreditCardDetails].[ProjectedRemaining],
		[DebtorCreditCardDetails].[ProjectedFee],
		[DebtorCreditCardDetails].[ProjectedCollectorFee]
	FROM [dbo].[Arrangements]
	INNER JOIN [dbo].[DebtorCreditCards]
		ON [DebtorCreditCards].[ArrangementId] = [Arrangements].[ID]
	INNER JOIN [dbo].[DebtorCreditCardDetails]
		ON [DebtorCreditCardDetails].[DebtorCreditCardID] = [DebtorCreditCards].[ID] 
	WHERE [Arrangements].[ID] = @ID
	AND [DebtorCreditCards].[IsActive] = 0
	AND (([DebtorCreditCards].[AuthErrCode] = 1 AND [NSFCount] >= 0) OR [NSFCount] = 1);
	
	RETURN 0;
END
GO
