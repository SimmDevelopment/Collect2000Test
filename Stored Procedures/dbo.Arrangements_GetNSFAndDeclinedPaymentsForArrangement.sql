SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_GetNSFAndDeclinedPaymentsForArrangement] @ID INTEGER
WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @PromiseIDs TABLE (
		[PromiseID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	DECLARE @PdcIDs TABLE (
		[PdcID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	DECLARE @PccIDs TABLE (
		[PccID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	INSERT INTO @PromiseIDs ([PromiseID])
	SELECT [Promises].[ID]
	FROM [dbo].[Promises]
	WHERE [Promises].[ArrangementId] = @ID
	AND [Promises].[Active] = 0
	AND [Promises].[Active] = 1;

	INSERT INTO @PdcIDs ([PdcID])
	SELECT [pdc].[UID]
	FROM [dbo].[pdc]
	WHERE [pdc].[ArrangementId] = @Id
	AND [pdc].[active] = 0
	AND [pdc].[NSFCount] = 1;

	INSERT INTO @PccIDs ([PccID])
	SELECT [DebtorCreditCards].[ID]
	FROM [dbo].[DebtorCreditCards]
	WHERE [DebtorCreditCards].[ArrangementId] = @Id
	AND [DebtorCreditCards].[IsActive] = 0
	AND (([DebtorCreditCards].[AuthErrCode] = 1 AND [NSFCount] >= 0) OR [NSFCount] = 1);

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
		[Arrangements].[ArrangementFee]
	FROM [dbo].[Promises]
	INNER JOIN @PromiseIDs AS [PromiseIDs]
	ON [Promises].[ID] = [PromiseIDs].[PromiseID]
	INNER JOIN [dbo].[Arrangements]
	ON [Promises].[ArrangementID] = [Arrangements].[ID];

	SELECT [PromiseDetails].[PromiseID],
		[PromiseDetails].[AccountID],
		[PromiseDetails].[Amount],
		CAST(0 AS MONEY) AS [Surcharge],
		[PromiseDetails].[Settlement],
		[PromiseDetails].[ProjectedCurrent],
		[PromiseDetails].[ProjectedRemaining],
		[PromiseDetails].[ProjectedFee],
		[PromiseDetails].[ProjectedCollectorFee]
	FROM [dbo].[PromiseDetails]
	INNER JOIN [dbo].[Promises]
	ON [PromiseDetails].[PromiseID] = [Promises].[ID]
	INNER JOIN @PromiseIDs AS [PromiseIDs]
	ON [PromiseDetails].[PromiseID] = [PromiseIDs].[PromiseID];

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
		[pdc].[DebtorBankID],
		[pdc].[PaymentLinkUID],
		[pdc].[NSFCount],
		[pdc].[DateUpdated],
		[DebtorBankInfo].[BankID],
		[DebtorBankInfo].[AccountNumber],
		[DebtorBankInfo].[AccountName],
		[DebtorBankInfo].[AccountAddress1],
		[DebtorBankInfo].[AccountAddress2],
		[DebtorBankInfo].[AccountCity],
		[DebtorBankInfo].[AccountState],
		[DebtorBankInfo].[AccountZipcode],
		[DebtorBankInfo].[AccountVerified],
		[DebtorBankInfo].[LastCheckNumber],
		[DebtorBankInfo].[AccountType],
		[DebtorBankInfo].[ABANumber],
		[DebtorBankInfo].[BankName],
		[DebtorBankInfo].[BankAddress],
		[DebtorBankInfo].[BankCity],
		[DebtorBankInfo].[BankState],
		[DebtorBankInfo].[BankZipcode],
		[DebtorBankInfo].[BankPhone],
		[Arrangements].[ID] AS [ArrangementID],
		[Arrangements].[SpreadAlgorithm],
		[PaymentSurchargeOverride].[SurchargeTypeId],
		[Arrangements].[FlatSurcharge],
		[Arrangements].[PercentageSurcharge],
		[Arrangements].[AddedFlatSurcharge],
		[Arrangements].[AddedPercentageSurcharge],
		[Arrangements].[ManualSurcharge],
		ISNULL( [pdc].[PaymentVendorTokenId], [DebtorBankInfo].[PaymentVendorTokenId] ) AS PaymentVendorTokenId,
		[Arrangements].[ArrangementFee]
	FROM [dbo].[pdc]
	INNER JOIN @PdcIDs AS [PdcIDs]
	ON [pdc].[UID] = [PdcIDs].[PdcID]
	INNER JOIN [dbo].[PdcBankRelationshipView]
	ON [pdc].[UID] = [PdcBankRelationshipView].[PdcID]
	LEFT JOIN [dbo].[DebtorBankInfo]
	ON [PdcBankRelationshipView].[DebtorBankID] = [DebtorBankInfo].[BankID]
	INNER JOIN [dbo].[Arrangements]
	ON [pdc].[ArrangementID] = [Arrangements].[ID]
	LEFT OUTER JOIN [dbo].[PaymentSurchargeOverride]
	ON [pdc].[UID] = [PaymentSurchargeOverride].[PaymentId]
	AND [PaymentSurchargeOverride].[PaymentTableId] = 1;

	SELECT [PdcDetails].[PdcID],
		[PdcDetails].[AccountID],
		[PdcDetails].[Amount],
		[PdcDetails].[Surcharge],
		[PdcDetails].[Settlement],
		[PdcDetails].[ProjectedCurrent],
		[PdcDetails].[ProjectedRemaining],
		[PdcDetails].[ProjectedFee],
		[PdcDetails].[ProjectedCollectorFee]
	FROM [dbo].[PdcDetails]
	INNER JOIN [dbo].[pdc]
	ON [pdc].[UID] = [PdcDetails].[PdcID]
	INNER JOIN @PdcIDs AS [PdcIDs]
	ON [PdcDetails].[PdcID] = [PdcIDs].[PdcID];

	SELECT  [DebtorCreditCards].[ID],
		[DebtorCreditCards].[Number],
		[DebtorCreditCards].[Name],
		[DebtorCreditCards].[Street1],
		[DebtorCreditCards].[Street2],
		[DebtorCreditCards].[City],
		[DebtorCreditCards].[State],
		[DebtorCreditCards].[Zipcode],
		[DebtorCreditCards].[CardNumber],
		[DebtorCreditCards].[EXPMonth],
		[DebtorCreditCards].[EXPYear],
		[DebtorCreditCards].[CreditCard],
		[DebtorCreditCards].[Amount] + COALESCE([DebtorCreditCards].[Surcharge], 0) AS [Amount],
		[DebtorCreditCards].[Printed],
		[DebtorCreditCards].[AuthErrCode],
		[DebtorCreditCards].[NSFCount],
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
		[DebtorCreditCards].[CCImageID],
		[DebtorCreditCards].[PaymentLinkUID],
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
		[Arrangements].[ArrangementFee]
	FROM [dbo].[DebtorCreditCards]
	INNER JOIN @PccIDs AS [PccIDs]
	ON [DebtorCreditCards].[ID] = [PccIDs].[PccID]
	LEFT OUTER JOIN [dbo].[imagefiles]
	ON [DebtorCreditCards].[CCImageID] = [imagefiles].[id]
	INNER JOIN [dbo].[Arrangements]
	ON [DebtorCreditCards].[ArrangementID] = [Arrangements].[ID]
	LEFT OUTER JOIN [dbo].[PaymentSurchargeOverride]
	ON [DebtorCreditCards].[ID] = [PaymentSurchargeOverride].[PaymentId]
	AND [PaymentSurchargeOverride].[PaymentTableId] = 2;

	SELECT [DebtorCreditCardDetails].[DebtorCreditCardID],
		[DebtorCreditCardDetails].[AccountID],
		[DebtorCreditCardDetails].[Amount],
		[DebtorCreditCardDetails].[Surcharge],
		[DebtorCreditCardDetails].[Settlement],
		[DebtorCreditCardDetails].[ProjectedCurrent],
		[DebtorCreditCardDetails].[ProjectedRemaining],
		[DebtorCreditCardDetails].[ProjectedFee],
		[DebtorCreditCardDetails].[ProjectedCollectorFee]
	FROM [dbo].[DebtorCreditCardDetails]
	INNER JOIN [dbo].[DebtorCreditCards]
	ON [DebtorCreditCards].[ID] = [DebtorCreditCardDetails].[DebtorCreditCardID]
	INNER JOIN @PccIDs AS [PccIDs]
	ON [DebtorCreditCardDetails].[DebtorCreditCardID] = [PccIDs].[PccID];

	RETURN 0;
END
GO
