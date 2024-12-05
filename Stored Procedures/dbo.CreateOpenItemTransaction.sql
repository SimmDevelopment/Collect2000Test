SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[CreateOpenItemTransaction] 
	@Invoice int, 
	@Amount money,
	@TransDate datetime,
	@TransType smallint,
	@Comment varchar(50), 
	@UID int OUTPUT
AS
	DECLARE @Err int

	INSERT INTO [OpenItemTransactions](
		[Amount], 
		[Invoice], 
		[TransDate], 
		[TransType], 
		[Comment])
	VALUES(
		@Amount, 
		@Invoice, 
		@TransDate, 
		@TransType, 
		@Comment)
	
	SELECT @Err = @@ERROR, @UID=SCOPE_IDENTITY()

	PRINT 'OpenItemTransactions record added with UID=' + CAST(@UID as varchar)
	
	RETURN @Err
		


GO
