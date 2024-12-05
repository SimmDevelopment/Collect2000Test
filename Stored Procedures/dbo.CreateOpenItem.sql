SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[CreateOpenItem]
	@SysYear int,
	@SysMonth int, 
	@Customer varchar(7), 
	@Invoice int,
	@InvDate datetime,
	@TransCode char(2),
	@Amount money,
	@Comment char(25),
	@InvoiceType char(2),
	@LatitudeUser varchar(256)
AS
	-- Return variable (0 = success)
	DECLARE @Err int
	DECLARE @Retired bit

	-- Identity value from inserted openitemtransaction record
	DECLARE @UID int

	-- initially all open items are not retired.
	SELECT @Retired = 0

	-- validate/default the @LatitudeUser value
	/* RFU
	IF @LatitudeUser is null 
		SELECT @LatitudeUser = suser_sname() 
	ELSE
		SELECT @LatitudeUser = @LatitudeUser
	*/

	INSERT INTO [OpenItem](
		[Invoice], 
		[Tdate], 
		[Tcode], 
		[Syyear], 
		[SyMonth], 
		[customer], 
		[Amount], 
		[Comment], 
		[Itype], 
		[Retired])
	VALUES(
		@Invoice, 
		@InvDate, 
		@TransCode, 
		@SysYear, 
		@SysMonth, 
		@Customer, 
		@Amount, 
		@Comment, 
		@InvoiceType, 
		@Retired)

	SELECT @Err = @@ERROR

	IF @Err = 0 
	BEGIN
		EXECUTE @Err = CreateInitialOpenItemTransaction @Invoice, @Amount, @InvDate, @UID OUTPUT
	END
	
	IF @Err = 0
	BEGIN
		PRINT 'Created OpenItem record with initial transacrion uid=' + CAST(@UID as varchar)
	END
	ELSE
	BEGIN
		PRINT 'Error creating OpenItem record, Error=' + CAST(@Err as varchar)
	END

	RETURN @Err

GO
