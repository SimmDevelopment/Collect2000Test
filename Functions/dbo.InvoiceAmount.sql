SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[InvoiceAmount] 
	(@Flags char(10) = '1111111111',
	@BucketNumber int,
	@BucketAmount money)
RETURNS money
AS
BEGIN
	DECLARE @BitFLag char(1)
	DECLARE @ReturnAmount money

	IF @BucketNumber < 1 OR @BucketNumber > 10 
		RETURN 0.00

	SELECT @BitFlag = SUBSTRING(isnull(@Flags, '1111111111'), @BucketNumber, 1)

	IF @BitFlag = '1'
		SELECT @ReturnAmount = @BucketAmount
	ELSE
		SELECT @ReturnAmount = 0.00

	RETURN @ReturnAmount
END

GO
