SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessAutoCollateral]
@client_id int,
@file_number int,
@CollateralYear int,
@Make [varchar](28),
@Model [varchar](28),
@Vin [varchar](30),
@Addons [varchar](200),
@Color [varchar](20),
@CollateralMilesHours [varchar](10),
@MilesHours [int],
@CollateralDamaged [varchar](1),
@CollateralTotaled [varchar](1),
@ConditionDescription [varchar](300),
@SellCollateral [varchar](1),
@IgnitionKeyNumber [varchar](10),
@OtherKeyNumber [varchar](10),
@TagDecalState [char](2),
@TagDecalNumber [varchar](10),
@TagDecalYear [int], 
@TitlePosition [smallint],
@TitleState [char](2),
@HaveTitle [varchar](1),
@DealerCode varchar(30),
@LegalCode varchar(10),
@VolumeDate datetime,
@FinanceChargeDue [money],
@LateChargeDue [money],
@DealerEndorsementCode varchar(10),
@DealerReserveChargeback [money],
@TerminationDate datetime,
@TerminationEffectiveDate datetime = NULL,
@FairMarketValue [money],
@PurchaseAmount [Money],
@ManufacturingCode [int],
@MSRP [Money],
@SeriesIdentifier [int],
@TitleStatus [int]
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

	IF NOT EXISTS(SELECT * FROM [dbo].[Auto_Collateral]  (NOLOCK) WHERE [AccountID] = @receiverNumber) 
	BEGIN
	
		INSERT INTO [dbo].[Auto_Collateral](
		[AccountID],
		[CollateralYear],
		[Make],
		[Model],
		[Vin],
		[Addons],
		[Color],
		[CollateralMilesHours],
		[MilesHours],
		[CollateralDamaged],
		[CollateralTotaled],
		[ConditionDescription],
		[SellCollateral],
		[IgnitionKeyNumber],
		[OtherKeyNumber],
		[TagDecalState],
		[TagDecalNumber],
		[TagDecalYear],
		[TitlePosition],
		[TitleState],
		[HaveTitle],
		[DealerCode],
		[LegalCode],
		[VolumeDate],
		[FinanceChargeDue],
		[LateChargeDue],
		[DealerEndorsementCode],
		[DealerReserveChargeback],
		[TerminationDate],
		[TerminationEffectiveDate],
		[FairMarketValue],
		[PurchaseAmount],
		[ManufacturingCode],
		[MSRP],
		[SeriesIdentifier],
		[TitleStatus])

		SELECT 
		@receiverNumber,--[AccountID] [int] NULL,
		@CollateralYear,--	[CollateralYear] [int] NULL,
		@Make,--[Make] [varchar](28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@Model,--[Model] [varchar](28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@Vin,--[Vin] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@Addons,--[Addons] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@Color,--[Color] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@CollateralMilesHours,--[CollateralMilesHours] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@MilesHours,--[MilesHours] [int] NULL,
		CASE WHEN @CollateralDamaged IN('1','Y','T') THEN 1 ELSE 0 END,--[CollateralDamaged] [bit] NULL,
		CASE WHEN @CollateralTotaled IN('1','Y','T') THEN 1 ELSE 0 END,--[CollateralTotaled] [bit] NULL,
		@ConditionDescription,--[ConditionDescription] [varchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CASE WHEN @SellCollateral IN('1','Y','T') THEN 1 ELSE 0 END,--	[SellCollateral] [bit] NULL,
		@IgnitionKeyNumber,--[IgnitionKeyNumber] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@OtherKeyNumber,--[OtherKeyNumber] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@TagDecalState,--[TagDecalState] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@TagDecalNumber,--[TagDecalNumber] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@TagDecalYear,--[TagDecalYear] [int] NULL,
		@TitlePosition,--[TitlePosition] [smallint] NULL,
		@TitleState,--[TitleState] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CASE WHEN @HaveTitle IN('1','Y','T') THEN 1 ELSE 0 END,--[HaveTitle] [bit] NULL,
		@DealerCode,--[DealerCode] varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@LegalCode,--[LegalCode] varchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@VolumeDate,--[VolumeDate] datetime NULL,
		@FinanceChargeDue,--[FinanceChargeDue] [money]  NULL,
		@LateChargeDue,--[LateChargeDue] [money]  NULL,
		@DealerEndorsementCode,--[DealerEndorsementCode] varchar(10)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		@DealerReserveChargeback,--[DealerReserveChargeback] [money]   NULL,
		@TerminationDate,--[TerminationDate] datetime NULL,
		@TerminationEffectiveDate,--[TerminationEffectiveDate] datetime NULL,
		@FairMarketValue,--[FairMarketValue] [money]  NULL,
		@PurchaseAmount,--[PurchaseAmount] [Money] NULL,
		@ManufacturingCode,--[ManufacturingCode] [int] NULL,
		@MSRP,--[MSRP] [money] NULL,
		@SeriesIdentifier,--[SeriesIdentifier] [int] NULL,
		@TitleStatus--[TitleStatus] [int] NULL

	END
	--ELSE
	--BEGIN
	--
	--
	--END
END

GO
