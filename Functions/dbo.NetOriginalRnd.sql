SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[NetOriginalRnd] (@AccountId Integer)
RETURNS MONEY
AS BEGIN
	
	DECLARE @output MONEY
	DECLARE @SumDA MONEY
	DECLARE @SumDAR MONEY
	DECLARE @Original MONEY

	SELECT @Original = m.original FROM master m WHERE m.number = @AccountId
	SELECT @SumDA = ISNULL(SUM(da.totalpaid),0.00) FROM payhistory da WHERE da.number = @AccountId AND da.batchtype = 'DA'
	SELECT @SumDAR = ISNULL(SUM(dar.totalpaid),0.00) FROM payhistory dar WHERE dar.number = @AccountId AND dar.batchtype = 'DAR'

	RETURN @Original - @SumDA + @SumDAR
END

GO
