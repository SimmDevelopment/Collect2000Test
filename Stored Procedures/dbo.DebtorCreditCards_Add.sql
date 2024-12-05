SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*DebtorCreditCards_Add*/
CREATE  Procedure [dbo].[DebtorCreditCards_Add]
	@Number		int,
	@DebtorID	int,
	@Name		varchar	(30),
	@Street1 	varchar	(30),
	@Street2 	varchar	(30),
	@City 		varchar	(25),
	@State 		varchar	(3),
	@Zipcode	varchar	(10),
	@CardNumber	varchar	(30),
	@EXPMonth	varchar	(2),
	@EXPYear	varchar	(2),
	@CreditCard	varchar	(4),
	@Amount		money,
	@ApprovedBy	varchar	(10),
	@Approved	datetime,
	@Code		varchar	(10),
	@DateEntered	smalldatetime,
	@DepositDate	smalldatetime,
	@LetterCode	varchar	(5),
	@ProjectedFee	money,
	@UseProjFee	bit,
	@PromiseMode	tinyint,
	@Surcharge	money,
	@CollectorFee	money,
	@LatitudeUser	varchar(255),
	@CCImageId uniqueidentifier,
	@DepositToGeneralTrust BIT = 0,
	@DepositSurchargeToOperatingTrust BIT = 0,
	@ArrangementID INTEGER = NULL,
	@ReturnID	int output

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

		INSERT INTO DebtorCreditCards(Number, DebtorID, Name, Street1, 
			Street2, City, State, Zipcode, CardNumber,
			EXPMonth, EXPYear, CreditCard, Amount, Printed, 
			ApprovedBy, Approved, Code, DateEntered, DepositDate,
			OnHoldDate, LetterCode, ProjectedFee, UseProjectedFee, 
			PromiseMode, Surcharge, CollectorFee, CreatedBy, CCImageId,
			DepositToGeneralTrust, DepositSurchargeToOperatingTrust, ArrangementID)
		VALUES(@Number, @DebtorID, @Name, @Street1, 
			@Street2, @City, @State, @Zipcode, @CardNumber,
			@ExpMonth, @ExpYear, @CreditCard, @Amount, 'N', 
			@ApprovedBy, @Approved, @Code, @DateEntered, @DepositDate,
			NULL, @LetterCode, @ProjectedFee, @UseProjFee, 
			@PromiseMode, @Surcharge, @CollectorFee, @LatitudeUser, @CCImageId,
			@DepositToGeneralTrust, @DepositSurchargeToOperatingTrust, @ArrangementID);

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
