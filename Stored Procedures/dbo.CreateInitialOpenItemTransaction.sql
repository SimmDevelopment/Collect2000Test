SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[CreateInitialOpenItemTransaction] 
	@Invoice int, 
	@Amount money,
	@TransDate datetime, 
	@UID int OUTPUT
AS
	DECLARE @Err int
	DECLARE @InitialDebitTransType int
	DECLARE @Comment varchar(50)

	SELECT @InitialDebitTransType=1, @Comment='Opening Balance'

	EXECUTE @Err = CreateOpenItemTransaction @Invoice, @Amount, @TransDate, @InitialDebitTransType, @Comment, @UID OUTPUT

	PRINT 'Initial OpenItemTransactions added with UID=' + CAST(@UID as varchar)

	RETURN @Err

GO
