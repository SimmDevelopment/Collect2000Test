SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessAutoLease]
@client_id int,
@file_number int,
@TermMonths [varchar](10),
@MaturityDate [DateTime],
@EffectiveDate [DateTime],
@OriginalMiles [Int],
@ContractMiles [Int],
@PurchaseMiles [Int], 
@EndofTermMiles [Int],
@Residual [Money],
@ContractObligation [Money],
@SecurityDeposit [Money],
@UnpaidMonthsPayment [money],
@UnpaidTax [Money], 
@ExcessMileage [Money],
@WearandTear [Money],
@ReturnDate [Datetime],
@ExcessMiles [int],
@UnusedMiles [Int], 
@InceptionMiles [int],
@MileageCredit [Money],
@MinorWearCharge [Money],
@MajorWearCharge [Money],
@DisposalAssessedAmount [Money],
@ResidualGainLoss [Money],
@EndofTermTaxAssessed [Money],
@OtherTaxAssessed [Money],
@DispositionDate [Datetime],
@InspectionReceivedDate [Datetime]
AS
BEGIN

	DECLARE @receiverNumber INT
	SELECT @receivernumber = max(receivernumber) FROM receiver_reference WITH (NOLOCK) WHERE sendernumber = @file_number and clientid = @client_id
	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END

	DECLARE @Qlevel varchar(5)

	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @receivernumber

	IF(@QLevel = '999') 
	BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
		RETURN
	END

	IF NOT EXISTS(SELECT * FROM [dbo].[Auto_Lease] (NOLOCK) WHERE [AccountID] = @receiverNumber) 
	BEGIN

		INSERT INTO [dbo].[Auto_Lease](
		[AccountID],
		[TermMonths],
		[MaturityDate],
		[EffectiveDate],
		[OriginalMiles],
		[ContractMiles],
		[PurchaseMiles],
		[EndofTermMiles],
		[Residual],
		[ContractObligation],
		[SecurityDeposit],
		[UnpaidMonthsPayment],
		[UnpaidTax],
		[ExcessMileage],
		[WearandTear],
		[ReturnDate],
		[ExcessMiles],
		[UnusedMiles],
		[InceptionMiles],
		[MileageCredit],
		[MinorWearCharge],
		[MajorWearCharge],
		[DisposalAssessedAmount],
		[ResidualGainLoss],
		[EndofTermTaxAssessed],
		[OtherTaxAssessed],
		[DispositionDate],
		[InspectionReceivedDate])

		SELECT
		@receiverNumber,--[AccountID] [int] NULL,
		@TermMonths,--[TermMonths] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@MaturityDate,--[MaturityDate] [DateTime] NULL,
		@EffectiveDate,--[EffectiveDate] [DATETIME] NULL,
		@OriginalMiles,--[OriginalMiles] [Int] NULL,
		@ContractMiles,--[ContractMiles] [int] NULL,
		@PurchaseMiles,--[PurchaseMiles] [int] NULL,
		@EndofTermMiles,--[EndofTermMiles] [int] NULL,
		@Residual,--[Residual] [Money] NULL,
		@ContractObligation,--[ContractObligation] [Money] NULL,
		@SecurityDeposit,--[SecurityDeposit] [Money] NULL,
		@UnpaidMonthsPayment,--[UnpaidMonthsPayment] [money] NULL,
		@UnpaidTax,--[UnpaidTax] [Money] NULL,
		@ExcessMileage,--[ExcessMileage] [Money] NULL,
		@WearandTear,--[WearandTear] [Money] null,
		@ReturnDate,--[ReturnDate] [Datetime] NULL,
		@ExcessMiles,--[ExcessMiles] [int] null,
		@UnusedMiles,--[UnusedMiles] [Int] NULL,
		@InceptionMiles,--[InceptionMiles] [int] NULL,
		@MileageCredit,--[MileageCredit] [Money] NULL,
		@MinorWearCharge,--[MinorWearCharge] [Money] NULL,
		@MajorWearCharge,--[MajorWearCharge] [Money] NULL,
		@DisposalAssessedAmount,--[DisposalAssessedAmount] [Money] NULL,
		@ResidualGainLoss,--[ResidualGainLoss] [Money] null,
		@EndofTermTaxAssessed,--[EndofTermTaxAssessed] [Money] null,
		@OtherTaxAssessed,--[OtherTaxAssessed] [Money] Null,
		@DispositionDate,--[DispositionDate] [Datetime] Null,
		@InspectionReceivedDate--[InspectionReceivedDate] [Datetime] NULL

	END
END

GO
