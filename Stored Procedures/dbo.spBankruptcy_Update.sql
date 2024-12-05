SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*spBankruptcy_Update*/
CREATE    PROCEDURE [dbo].[spBankruptcy_Update]
	@BankruptcyID int,
	@Chapter tinyint,
	@DateFiled datetime,
	@CaseNumber varchar (20),
	@CourtDistrict varchar (200),
	@CourtDivision varchar (100),
	@CourtStreet1 varchar (50),
	@CourtStreet2 varchar (50),
	@CourtCity varchar (50),
	@CourtState varchar(3),
	@CourtZipcode varchar (15),
	@CourtPhone varchar (50),
	@Trustee varchar (50),
	@TrusteeStreet1 varchar (50),
	@TrusteeStreet2 varchar (50),
	@TrusteeCity varchar (100),
	@TrusteeState varchar (3),
	@TrusteeZipcode varchar (10),
	@TrusteePhone varchar (30),
	@Has341Info bit,
	@DateTime341 datetime,
	@Location341 varchar (200),
	@Comments varchar (500),
	@Status varchar (100),
	@ConvertedFrom TINYINT,
	@DateNotice DATETIME,
	@ProofFiled DATETIME,
	@DischargeDate DATETIME,
	@DismissalDate DATETIME,
	@ConfirmationHearingDate DATETIME,
	@HasAsset BIT,
	@Reaffirm CHAR(1),
	@ReaffirmDateFiled DATETIME,
	@ReaffirmAmount MONEY,
	@ReaffirmTerms VARCHAR(50),
	@VoluntaryDate DATETIME,
	@VoluntaryAmount MONEY,
	@VoluntaryTerms VARCHAR(50),
	@SurrenderDate DATETIME,
	@SurrenderMethod VARCHAR(50),
	@AuctionHouse VARCHAR(50),
	@AuctionDate DATETIME,
	@AuctionAmount MONEY,
	@AuctionFee MONEY,
	@AuctionAmountApplied MONEY,
	@SecuredAmount MONEY,
	@SecuredPercentage SMALLMONEY,
	@UnsecuredAmount MONEY,
	@UnsecuredPercentage SMALLMONEY
AS
	UPDATE Bankruptcy  SET
		Chapter = @Chapter,
		DateFiled = @DateFiled,
		CaseNumber = @CaseNumber,
		CourtDistrict = @CourtDistrict,
		CourtDivision = @CourtDivision,
		CourtStreet1=@CourtStreet1,
		CourtStreet2=@CourtStreet2, 
		CourtCity=@CourtCity,
		CourtState = @CourtState,
		CourtZipcode=@CourtZipcode,
		CourtPhone = @CourtPhone,
		Trustee=@Trustee,
		TrusteeStreet1=@TrusteeStreet1,
		TrusteeStreet2=@TrusteeStreet2,
		TrusteeCity=@TrusteeCity,
		TrusteeState = @TrusteeState,
		TrusteeZipcode = @TrusteeZipcode,
		TrusteePhone=@TrusteePhone,
		Has341Info=@Has341Info,
		DateTime341=@DateTime341,
		Location341=@Location341,
		Comments=@Comments,
		Status = @Status,
		[ConvertedFrom] = @ConvertedFrom,
		[DateNotice] =  @DateNotice, 
		[ProofFiled] =  @ProofFiled, 
		[DischargeDate] =  @DischargeDate, 
		[DismissalDate] =  @DismissalDate, 
		[ConfirmationHearingDate] =  @ConfirmationHearingDate, 
		[HasAsset] =  @HasAsset, 
		[Reaffirm] =  @Reaffirm, 
		[ReaffirmDateFiled] =  @ReaffirmDateFiled, 
		[ReaffirmAmount] =  @ReaffirmAmount, 
		[ReaffirmTerms] =  @ReaffirmTerms, 
		[VoluntaryDate] =  @VoluntaryDate, 
		[VoluntaryAmount] =  @VoluntaryAmount, 
		[VoluntaryTerms] =  @VoluntaryTerms, 
		[SurrenderDate] =  @SurrenderDate, 
		[SurrenderMethod] =  @SurrenderMethod, 
		[AuctionHouse] =  @AuctionHouse, 
		[AuctionDate] =  @AuctionDate, 
		[AuctionAmount] =  @AuctionAmount, 
		[AuctionFee] =  @AuctionFee, 
		[AuctionAmountApplied] =  @AuctionAmountApplied, 
		[SecuredAmount] =  @SecuredAmount, 
		[SecuredPercentage] =  @SecuredPercentage, 
		[UnsecuredAmount] =  @UnsecuredAmount, 
		[UnsecuredPercentage] = @UnsecuredPercentage
	WHERE BankruptcyID = @BankruptcyID
	
	Return @@Error




GO
