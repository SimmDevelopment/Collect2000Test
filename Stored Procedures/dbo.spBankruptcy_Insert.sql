SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*spBankruptcy_Insert*/
CREATE   PROCEDURE [dbo].[spBankruptcy_Insert]
	@AccountID int,
	@DebtorID int,
	@Chapter tinyint,
	@DateFiled datetime,
	@CaseNumber varchar (20),
	@CourtDistrict varchar (200),
	@CourtDivision varchar (100),
	@CourtStreet1 varchar (50),
	@CourtStreet2 varchar (50),
	@CourtCity varchar (50),
	@CourtState varchar (3),
	@CourtZipcode varchar (15),
	@CourtPhone varchar (50),
	@Trustee varchar (50),
	@TrusteeStreet1 varchar (50),
	@TrusteeStreet2 varchar (50),
	@TrusteeCity varchar(100),
	@TrusteeState varchar(3),
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
	@UnsecuredPercentage SMALLMONEY,
	@ReturnID int output
AS
	INSERT INTO Bankruptcy (AccountID, DebtorID, Chapter, DateFiled, CaseNumber, CourtDistrict, CourtDivision, CourtStreet1, CourtStreet2, 
	CourtCity, CourtState, CourtZipcode, CourtPhone,Trustee, TrusteeStreet1, TrusteeStreet2, TrusteeCity, TrusteeState, TrusteeZipcode, TrusteePhone, 
	Has341Info, DateTime341, Location341, Comments, Status, [ConvertedFrom], [DateNotice], [ProofFiled], [DischargeDate], [DismissalDate], [ConfirmationHearingDate], [HasAsset], [Reaffirm], [ReaffirmDateFiled], [ReaffirmAmount], [ReaffirmTerms], [VoluntaryDate], [VoluntaryAmount], [VoluntaryTerms], [SurrenderDate], [SurrenderMethod], [AuctionHouse], [AuctionDate], [AuctionAmount], [AuctionFee], [AuctionAmountApplied], [SecuredAmount], [SecuredPercentage], [UnsecuredAmount], [UnsecuredPercentage])
	VALUES (@AccountID, @DebtorID, @Chapter, @DateFiled, @CaseNumber, @CourtDistrict, @CourtDivision,  @CourtStreet1, @CourtStreet2,
	@CourtCity, @CourtState, @CourtZipcode, @CourtPhone, @Trustee, @TrusteeStreet1, @TrusteeStreet2, @TrusteeCity, @TrusteeState, @TrusteeZipcode, 
	@TrusteePhone, @Has341Info, @DateTime341,
	@Location341, @Comments, @Status, @ConvertedFrom, @DateNotice, @ProofFiled, @DischargeDate, @DismissalDate, @ConfirmationHearingDate, @HasAsset, @Reaffirm, @ReaffirmDateFiled, @ReaffirmAmount, @ReaffirmTerms, @VoluntaryDate, @VoluntaryAmount, @VoluntaryTerms, @SurrenderDate, @SurrenderMethod, @AuctionHouse, @AuctionDate, @AuctionAmount, @AuctionFee, @AuctionAmountApplied, @SecuredAmount, @SecuredPercentage, @UnsecuredAmount, @UnsecuredPercentage)
	
	IF @@Error = 0 BEGIN
		Select @ReturnID = SCOPE_IDENTITY();
		Return 0
	END
	ELSE
		Return @@Error



GO
