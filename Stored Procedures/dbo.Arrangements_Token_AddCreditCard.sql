SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  Procedure [dbo].[Arrangements_Token_AddCreditCard]
	@Number		INTEGER,
	@DebtorID	INTEGER,
	@PaymentVendorTokenId INTEGER,
	@MaskedCardNumber	VARCHAR	(30),
	@MailingName VARCHAR(30),
	@MailingStreet1 VARCHAR(30),
	@MailingStreet2 VARCHAR(30),
	@MailingCity VARCHAR(25),
	@MailingState VARCHAR(3),
	@MailingZipCode VARCHAR(10),
	@EXPMonth	VARCHAR	(2),
	@EXPYear	VARCHAR	(4),
	@CreditCard	VARCHAR	(4),
	@Amount		MONEY,
	@ApprovedBy	VARCHAR	(10),
	@Approved	DATETIME,
	@Code		VARCHAR	(10),
	@DateEntered	SMALLDATETIME,
	@DepositDate	SMALLDATETIME,
	@LetterCode	VARCHAR	(5),
	@ProjectedFee	MONEY,
	@UseProjFee	BIT,
	@PromiseMode	TINYINT,
	@Surcharge	MONEY,
	@CollectorFee	MONEY,
	@LatitudeUser	VARCHAR(255),
	@DepositToGeneralTrust BIT = 0,
	@DepositSurchargeToOperatingTrust BIT = 0,
	@ArrangementID INTEGER = NULL,
	@ReturnID	INTEGER output

AS
	Declare @QLevel varchar(3)
	Declare @AcctState varchar(3)
	Declare @ReturnError int 
	Declare @Rowcount int

	IF ISNULL(@LatitudeUser, suser_sname()) = '' 
		Select @LatitudeUser = suser_sname()
	ELSE
		Select @LatitudeUser = @LatitudeUser

	Select @QLevel = QLevel, @AcctState = State 
	from master 
	WHERE number = @Number
	SELECT @ReturnError = @@Error, @Rowcount = @@ROWCOUNT
	IF (@Rowcount = 0) 
	BEGIN
		PRINT 'Account does not exist'
		Return -1
	END
	ELSE IF @ReturnError <> 0
	BEGIN
		Return @ReturnError
	END
	ELSE IF @QLevel in ('998', '999') 
	BEGIN
		PRINT 'Closed QLevel'
		Return -1
	END
	ELSE 
	BEGIN

		IF EXISTS (SELECT * FROM [dbo].[StateRestrictions] WHERE [abbreviation] = @AcctState AND [PermitSurcharge] = 0) BEGIN
			SET @Surcharge = 0;
		END;

		INSERT INTO DebtorCreditCards(Number, DebtorID, CardNumber,
			EXPMonth, EXPYear, CreditCard, Amount, Printed, 
			ApprovedBy, Approved, Code, DateEntered, DepositDate,
			OnHoldDate, LetterCode, ProjectedFee, UseProjectedFee, 
			PromiseMode, Surcharge, CollectorFee, CreatedBy, PaymentVendorTokenId,
			DepositToGeneralTrust, DepositSurchargeToOperatingTrust, ArrangementID, 
			Name, Street1, Street2, City, State, Zipcode)
		VALUES (@Number, @DebtorID, @MaskedCardNumber,
			@ExpMonth, @ExpYear, @CreditCard, @Amount, 'N', 
			@ApprovedBy, @Approved, @Code, @DateEntered, @DepositDate,
			NULL, @LetterCode, @ProjectedFee, @UseProjFee, 
			@PromiseMode, @Surcharge, @CollectorFee, @LatitudeUser, @PaymentVendorTokenId,
			@DepositToGeneralTrust, @DepositSurchargeToOperatingTrust, @ArrangementID,
			@MailingName, @MailingStreet1, @MailingStreet2, @MailingCity, @MailingState, @MailingZipcode);

		SET @ReturnError = @@Error
		IF @ReturnError = 0 
		BEGIN
			Select @ReturnID = SCOPE_IDENTITY()
			Return 0
		END
		ELSE 
		BEGIN
			PRINT 'Error in Insert'
			Return @ReturnError
		END		
	END
GO
