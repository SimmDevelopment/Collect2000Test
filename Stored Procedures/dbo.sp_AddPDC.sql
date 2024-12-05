SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_AddPDC*/
CREATE PROCEDURE [dbo].[sp_AddPDC]
	@AcctID int,
	@Seq int,
	@PMethodID tinyint,
	@DepositDate datetime,
	@Amount money,
	@CheckNo varchar (20),
	@LetterCode varchar (5),
	@SurCharge money,
	@PromiseMode tinyint,
	@ProjectedFee money,
	@CollectorFee money,
	@LatitudeUser	varchar(255),
	@Desk varchar (10) output,
	@Customer varchar (7) output,
	@SurchargeCheckNbr CHAR(10) = NULL,
	@DepositToGeneralTrust BIT = 0,
	@DebtorBankID INTEGER = NULL,
	@ArrangementID INTEGER = NULL,
	@PaymentVendorTokenID INTEGER = NULL,
	@ReturnMessage varchar(30) output,
	@ReturnUID int output

 /*
**Name            :sp_AddPDC
**Function        :Adds a record to the PDC table
**Creation        :
**Used by         :C2KPromise.dll
**Change History  :10/21/2004	mr Added CollectorFee 
*/


AS
	Declare @Entered datetime
	Declare @QLevel varchar(3)
	Declare @Printed bit
	Declare @State varchar(3)
	Declare @ReturnError int 
	Declare @Rowcount int

	IF (@PMethodID = 6) or (@PMethodID = 7)	--Paper Draft or ACHDebit
		SET @Printed = 0
	ELSE	
		SET @Printed = 1

	set @Entered = cast(CONVERT(varchar, GETDATE(), 107)as datetime)

	IF ISNULL(@LatitudeUser, suser_sname()) = '' 
		Select @LatitudeUser = suser_sname()
	ELSE
		Select @LatitudeUser = @LatitudeUser

	Select @Desk=Desk, @Customer=Customer, @QLevel = QLevel, @State = State 
	from master 
	WHERE number = @AcctID
	SELECT @ReturnError = @@Error, @Rowcount = @@ROWCOUNT
	IF (@Rowcount = 0) 
	BEGIN
		SET @ReturnMessage = 'Account does not exist'
		Return -1
	END
	ELSE IF @ReturnError <> 0
	BEGIN
		Return @ReturnError
	END
	ELSE IF @State IN ('MA', 'RI') AND @depositdate > DATEADD(dd, 5, GETDATE()) --DATEPART(mm, GETDATE()) <> DATEPART(mm, @depositdate)
	BEGIN
		PRINT 'Future Payments Past 5 days not permitted for MA and RI'
		RETURN -1
	END
	ELSE IF @QLevel in ('998', '999') 
	BEGIN
		SET @ReturnMessage = 'Closed QLevel'
		Return -1
	END
	--allow payments Saturday 3/30/2019 for PayPal only
	ELSE IF DATENAME(weekday, @depositdate) IN ('Saturday', 'Sunday') --AND @customer NOT IN ('0001220', '0001256', '0001257', '0001258') AND dbo.date(@depositdate) = '20190330'
	--ELSE IF	(DATENAME(weekday, @depositdate) IN ('Saturday', 'Sunday') AND @customer NOT IN ('0001220', '0001256', '0001257', '0001258')) 
	--OR (DATENAME(weekday, @depositdate) IN ('Saturday', 'Sunday') AND @customer IN ('0001220', '0001256', '0001257', '0001258') and dbo.date(@depositdate) <> '20190330')
	BEGIN
		SET @ReturnMessage = 'Weekend Payments not Permitted'
		RETURN -1
	END
	ELSE IF @customer IN ('0001530', '0001532', '0001533', '0001548') --Oliphant
		AND @depositdate IN ('20170128', '20170129', '20170130', '20170131', '20170225', '20170226', '20170227', '20170228', '20170329', '20170330', '20170331', '20170427', '20170428', '20170429', '20170430', '20170529', '20170530', '20170531', '20170629', '20170630', '20170729', '20170730', '20170731', '20170829', '20170830', '20170831', '20170929', '20170930', '20171028', '20171029', '20171030', '20171031', '20171129', '20171130', '20171229', '20171230', '20171231')
	BEGIN
		print 'EOM Payments not Permitted'
		RETURN -1
	END
	ELSE IF @customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (191))--191 = Security Credit Services
		AND @depositdate IN ('20170128', '20170129', '20170130', '20170131', '20170225', '20170226', '20170227', '20170228', '20170330', '20170331', '20170427', '20170428', '20170429', '20170430', '20170527', '20170528', '20170529', '20170530', '20170531', '20170629', '20170630', '20170728', '20170729', '20170730', '20170731', '20170830', '20170831', '20170928', '20170929', '20170930', '20171028', '20171029', '20171030', '20171031', '20171129', '20171130', '20171228', '20171229', '20171230', '20171231')
	BEGIN
		print 'EOM Payments not Permitted'
		RETURN -1
	END
	ELSE IF @customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (135))--135 = Hyundai
		AND @depositdate IN ('20170127', '20170128', '20170129', '20170130', '20170131', '20170225', '20170226', '20170227', '20170228', '20170330', '20170331', '20170427', '20170428', '20170429', '20170430', '20170527', '20170528', '20170529', '20170530', '20170531', '20170629', '20170630', '20170728', '20170729', '20170730', '20170731', '20170830', '20170831', '20170928', '20170929', '20170930', '20171028', '20171029', '20171030', '20171031', '20171230', '20171231')
	BEGIN
		print 'EOM Payments not Permitted'
		RETURN -1
	END
	ELSE IF @customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (178))--178 = Vericrest/Caliber
		AND @depositdate IN ('20170131', '20170228', '20170331', '20170429', '20170430', '20170531', '20170630', '20170729', '20170730', '20170731', '20170831', '20170929', '20171031', '20171130', '20171229', '20171230', '20171231')
	BEGIN
		print 'EOM Payments not Permitted'
		RETURN -1
	END
	ELSE IF @customer IN (SELECT DISTINCT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID in (181) OR customerid IN ('0001410', '0001411'))--181 = Sun Trust/DDA/Deceased CC
		AND @depositdate IN ('20170131', '20170228', '20170331', '20170428', '20170429', '20170430', '20170531', '20170630', '20170729', '20170730', '20170731', '20170831', '20170929', '20170930', '20171031', '20171130', '20181229', '20181230', '20181231')
	BEGIN
		print 'EOM Payments not Permitted'
		RETURN -1
	END
	ELSE IF @customer IN ('0001472')--Go Financial
		AND @depositdate IN ('20170131', '20170227', '20170331', '20170428', '20170429', '20170430', '20170530', '20170531', '20170629', '20170630', '20170729', '20170730', '20170731', '20170831', '20170929', '20170930', '20171031', '20171130', '20171229', '20171230', '20171231')
	BEGIN
		print 'EOM Payments not Permitted'
		RETURN -1
	END
	ELSE IF @customer IN ('0001055')-- = Western Alliance Previously (Partners First)
		AND @depositdate IN ('20170126', '20170127', '20170128', '20170129', '20170130', '20170131', '20170226', '20170227', '20170228', '20170326', '20170327', '20170328', '20170329', '20170330', '20170331', '20170426', '20170427', '20170428', '20170429', '20170430', '20170526', '20170527', '20170528', '20170529', '20170530', '20170531', '20170626', '20170627', '20170628', '20170629', '20170630', '20170726', '20170727', '20170728', '20170729', '20170730', '20170731', '20170826', '20170827', '20170828', '20170829', '20170830', '20170831', '20170926', '20170927', '20170928', '20170929', '20170930', '20171026', '20171027', '20171028', '20171029', '20171030', '20171031', '20171126', '20171127', '20171128', '20171129', '20171130', '20171226', '20171227', '20171228', '20171229', '20171230', '20171231')
	BEGIN
		print 'EOM Payments not Permitted'
		RETURN -1
	END
	ELSE IF @customer IN ('0001636')-- = American First Financial
		AND @depositdate IN ('20170126', '20170127', '20170128', '20170129', '20170130', '20170131', '20170226', '20170227', '20170228', '20170326', '20170327', '20170328', '20170329', '20170330', '20170331', '20170426', '20170427', '20170428', '20170429', '20170430', '20170526', '20170527', '20170528', '20170529', '20170530', '20170531', '20170626', '20170627', '20170628', '20170629', '20170630', '20170726', '20170727', '20170728', '20170729', '20170730', '20170731', '20170826', '20170827', '20170828', '20170829', '20170830', '20170831', '20170926', '20170927', '20170928', '20170929', '20170930', '20171026', '20171027', '20171028', '20171029', '20171030', '20171031', '20171126', '20171127', '20171128', '20171129', '20171130', '20171229', '20171230', '20171231')
	BEGIN
		print 'EOM Payments not Permitted'
		RETURN -1
	END
	ELSE
	BEGIN

		IF EXISTS (SELECT * FROM [dbo].[StateRestrictions] WHERE [abbreviation] = @State AND [PermitSurcharge] = 0) BEGIN
			SET @Surcharge = 0;
		END;

		INSERT INTO PDC(number, SEQ, PDC_Type, Entered, 
				OnHold, 
				deposit, Amount, Checknbr, 
				LtrCode, Desk, Customer, Surcharge, 
				PromiseMode, Printed, ProjectedFee, 
				CollectorFee, CreatedBy, SurchargeCheckNbr,
				DepositToGeneralTrust, DebtorBankID,
				ArrangementID, PaymentVendorTokenID)
			VALUES(@AcctID, @seq, @PMethodID, @Entered, 
				cast(CONVERT(varchar, GETDATE(), 107)as datetime), 
				@DepositDate, @Amount, @CheckNo, 
				@LetterCode, @Desk, @Customer, @SurCharge, 
				@PromiseMode, @Printed, @ProjectedFee, 
				@CollectorFee, @LatitudeUser, @SurchargeCheckNbr,
				@DepositToGeneralTrust, @DebtorBankID,
				@ArrangementID, @PaymentVendorTokenID)

		SET @ReturnError = @@Error
		IF @ReturnError = 0 
		BEGIN
			Select @ReturnUID = SCOPE_IDENTITY()
			Return 0
		END
		ELSE 
		BEGIN
			SET @ReturnMessage = 'Error in Insert'
			Return @ReturnError
		END		
	END
GO
