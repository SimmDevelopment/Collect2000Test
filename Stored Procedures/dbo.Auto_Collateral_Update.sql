SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Auto_Collateral_Update]
    @accountID int,
    @addOns varchar(200),
    @collateralMilesHours varchar(10),
    @collateralYear int,
    @collateralDamaged bit,
    @collateralTotaled bit,
    @color varchar(20),
    @conditionDescription varchar(300),
    @haveTitle bit,
    @ignitionKeyNumber varchar(10),
    @make varchar(28),
    @milesHours int,
    @model varchar(28),
    @otherKeyNumber varchar(10),
    @sellCollateral bit,
    @tagDecalNumber varchar(10),
    @tagDecalState char(2),
    @tagDecalYear int,
    @titlePosition smallint,
    @titleState char(2),
    @vin varchar(30),
    @dealerCode varchar(30),
	@legalCode varchar(10),
	@volumedate datetime = NULL,
	@financeChargeDue money,
	@lateChargeDue money,
	@dealerEndorsementCode varchar(10),
	@dealerReserveChargeback money,
	@terminationDate datetime  = NULL,
	@terminationEffectiveDate datetime  = NULL,
	@fairMarketValue money,
	@purchaseAmount money,
	@manufacturingCode int,
	@msrp money,
	@seriesIdentifier int,
	@titleStatus int

as
begin
 
      if exists (select accountID from Auto_Collateral where accountID = @accountID)
      begin
            update [dbo].[Auto_Collateral]
            set AddOns = @addOns,
                  CollateralMilesHours = @collateralMilesHours,
                  CollateralYear = @collateralYear,
                  CollateralDamaged = @collateralDamaged,
                  CollateralTotaled = @collateralTotaled,
                  Color = @color,
                  ConditionDescription = @conditionDescription,
                  HaveTitle = @haveTitle,
                  IgnitionKeyNumber = @ignitionKeyNumber,
                  Make = @make,
                  MilesHours = @milesHours,
                  Model = @model,
                  OtherKeyNumber = @otherKeyNumber,
                  SellCollateral = @sellCollateral,
                  TagDecalNumber = @tagDecalNumber,
                  TagDecalState = @tagDecalState,
                  TagDecalYear = @tagDecalYear,
                  TitlePosition = @titlePosition,
                  TitleState = @titleState,
                  Vin = @vin,
				  DealerCode = @dealerCode,
				  LegalCode = @legalCode,
				  VolumeDate = @volumedate,
				  FinanceChargeDue = @financeChargeDue,
				  LateChargeDue = @lateChargeDue,
				  DealerEndorsementCode = @dealerEndorsementCode,
				  DealerReserveChargeBack = @dealerReserveChargeback,
				  TerminationDate = @terminationDate,
				  TerminationEffectiveDate = @terminationEffectiveDate,
				  FairMarketValue = @fairMarketValue,
				  PurchaseAmount = @purchaseAmount,
				  ManufacturingCode = @manufacturingCode,
				  MSRP = @msrp,
				  SeriesIdentifier = @seriesIdentifier,
				  TitleStatus = @titleStatus
            where accountID = @accountID
      end
      else
      begin
            insert into [dbo].[Auto_Collateral]
                  (accountID, AddOns, CollateralMilesHours, CollateralYear, CollateralDamaged, CollateralTotaled, Color,
             ConditionDescription, HaveTitle, IgnitionKeyNumber, Make, MilesHours, Model, OtherKeyNumber, SellCollateral,
             TagDecalNumber, TagDecalState, TagDecalYear, TitlePosition, TitleState, Vin, 
			 DealerCode, LegalCode, VolumeDate, FinanceChargeDue, LateChargeDue,
			 DealerEndorsementCode, DealerReserveChargeBack, TerminationDate, TerminationEffectiveDate,
			 FairMarketValue, PurchaseAmount, ManufacturingCode, MSRP,
			 SeriesIdentifier, TitleStatus
)
            values
                  (@accountID, @addOns, @collateralMilesHours, @collateralYear, @collateralDamaged, @collateralTotaled, @color,
                   @conditionDescription, @haveTitle, @ignitionKeyNumber, @make, @milesHours, @model, @otherKeyNumber, @sellCollateral,
                   @tagDecalNumber, @tagDecalState, @tagDecalYear, @titlePosition, @titleState, @vin,
					@dealerCode, @legalCode, @volumeDate, @financeChargeDue, @lateChargeDue,
					@dealerEndorsementCode, @dealerReserveChargeBack, @terminationDate, @terminationEffectiveDate,
					@fairMarketValue, @purchaseAmount, @manufacturingCode, @msrp,
					@seriesIdentifier, @titleStatus
)
      end
end

GO
