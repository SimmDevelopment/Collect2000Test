SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[InvoiceAmountTotal] 
	(@Flags char(10) = '1111111111',
	@Bucket1 money,
	@Bucket2 money,
	@Bucket3 money,
	@Bucket4 money,
	@Bucket5 money,
	@Bucket6 money,
	@Bucket7 money,
	@Bucket8 money,
	@Bucket9 money,
	@Bucket10 money)
RETURNS money
AS
BEGIN
	DECLARE @ReturnAmount money

	SELECT @ReturnAmount = (dbo.InvoiceAmount( @Flags, 1, @Bucket1) + 
							dbo.InvoiceAmount( @Flags, 2, @Bucket2) + 
							dbo.InvoiceAmount( @Flags, 3, @Bucket3) + 
							dbo.InvoiceAmount( @Flags, 4, @Bucket4) + 
							dbo.InvoiceAmount( @Flags, 5, @Bucket5) + 
							dbo.InvoiceAmount( @Flags, 6, @Bucket6) + 
							dbo.InvoiceAmount( @Flags, 7, @Bucket7) + 
							dbo.InvoiceAmount( @Flags, 8, @Bucket8) + 
							dbo.InvoiceAmount( @Flags, 9, @Bucket9) + 
							dbo.InvoiceAmount(@Flags, 10, @Bucket10))
	
	RETURN @ReturnAmount
END

GO
