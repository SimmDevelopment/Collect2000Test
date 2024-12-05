SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[CreateServiceInvoice]
	@Customer varchar(7), 
	@InvDate datetime,
	@Description varchar(128),
	@FeeAmount money,
	@Taxes money,
	@LatitudeUser varchar(256),
	@InvoiceNumber int OUTPUT
AS
	DECLARE @InvoiceAmount money

	-- Return variable (0 = success)
	DECLARE @Err int

	-- Place holder for @@ROWCOUNT value
	DECLARE @RowCount int

	-- Service invoice values
	DECLARE @InvoiceType int
	DECLARE @TransCode char(2)
	DECLARE @IType char(2)

	-- System values
	DECLARE @SysYear int
	DECLARE @SysMonth int

	-- customers values
	DECLARE @ShowBalance bit
	DECLARE @ShowRecieved bit
	DECLARE @ShowAmtDueClient bit
	DECLARE @InvoiceSort tinyint

	-- Call our sp to get the next invoice number...
	-- Don't include this inside a transaction. It is
	-- OK if the invoice number is wasted should we 
	-- rollback at the end of this...
	EXECUTE @Err = NextInvoiceNumber @InvoiceNumber OUTPUT

	-- If we couldn't get an invoice number then we cannot continue
	IF @Err <> 0 RETURN @Err

	-- Set the serviceinvoice specific values...
	SELECT @IType='4', @InvoiceType=1, @TransCode='00', @InvoiceAmount=(@FeeAmount + @Taxes)

	-- Query the customer for needed values...
	SELECT TOP 1 @ShowBalance=InvShowBal,
		@ShowRecieved=InvShowRcvd,
		@ShowAmtDueClient=InvShowOther,
		@InvoiceSort=CAST( SUBSTRING(InvoiceSort,1,1) as tinyint)
	FROM customer c
	WHERE c.customer = @Customer

	-- check for success
	SELECT @Err = @@ERROR, @RowCount = @@ROWCOUNT

	-- What do we do if there is no matching customer record
	IF @RowCount = 0
	BEGIN
		PRINT 'Error: ' + CAST(@Err AS varchar)
		PRINT 'Row Count: ' + CAST(@RowCount AS varchar)
		RETURN(-1)
	END

	-- Query the customer for needed values...
	SELECT TOP 1 @SysYear=c.currentyear,
		@SysMonth=c.currentmonth
	FROM controlfile c

	-- check for success
	SELECT @Err = @@ERROR, @RowCount = @@ROWCOUNT

	-- What do we do if there is no controlfile record
	IF @RowCount = 0
	BEGIN
		PRINT 'Error: ' + CAST(@Err AS varchar)
		PRINT 'Row Count: ' + CAST(@RowCount AS varchar)
		RETURN(-2)
	END

	-- validate/default the @LatitudeUser value
	IF @LatitudeUser is null 
		SELECT @LatitudeUser = suser_sname() 
	ELSE
		SELECT @LatitudeUser = @LatitudeUser

	-- Begin a transaction now...
	BEGIN TRANSACTION

	-- Insert the new invoice record...
	INSERT INTO [InvoiceSummary](
		[Invoice], 
		[Tdate], 
		[Tcode], 
		[Syyear], 
		[SyMonth], 
		[customer], 
		[AmountA], 
		[AmountB], 
		[AmountC], 
		[AmountD], 
		[AmountE], 
		[AmountF], 
		[Itype], 
		[SortOn], 
		[ShowBalance], 
		[ShowRcvd], 
		[NetGross], 
		[SepCombined], 
		[ShowAmtDueClient], 
		[ByPassDPs], 
		[Tax], 
		[WithHeldAmt], 
		[Created],
		[CreatedBy],
		[Description],
		[InvoiceType])
	VALUES(
		@InvoiceNumber, 
		@InvDate, 
		@TransCode, 
		@SysYear, 
		@SysMonth, 
		@Customer, 
		0.0, 
		0.0, 
		@FeeAmount, 
		@InvoiceAmount, 
		0.0, 
		0.0, 
		@IType, 
		@InvoiceSort, 
		@ShowBalance, 
		@ShowRecieved, 
		1, 
		1, 
		@ShowAmtDueClient, 
		0, 
		@Taxes, 
		0.0, 
		GETDATE(),
		@LatitudeUser,
		@Description,
		@InvoiceType)

	-- check for success
	SELECT @Err = @@ERROR, @RowCount = @@ROWCOUNT

	-- Create an openitem (and initial openitemtransaction)
	IF @Err = 0 AND @RowCount > 0
	BEGIN
		Execute @Err = CreateOpenItem @SysYear, @SysMonth, @Customer, @InvoiceNumber, @InvDate, @TransCode, @InvoiceAmount, @Description, @InvoiceType, @LatitudeUser
	END

	IF @Err <> 0 
	BEGIN
		ROLLBACK TRANSACTION
		PRINT 'CreateServiceInvoice failed, Error=' + CAST(@Err as varchar) + ': for invoice number ' + CAST(@InvoiceNumber as varchar)
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION
		PRINT 'CreateServiceInvoice succeded, invoice number=' + CAST(@InvoiceNumber as varchar)
	END
	
	RETURN @Err

GO
