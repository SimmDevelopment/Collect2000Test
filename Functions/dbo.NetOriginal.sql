SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[NetOriginal] (@AccountId Integer)
RETURNS MONEY
AS BEGIN
	
	DECLARE @output DECIMAL
	DECLARE @SumDA DECIMAL
	DECLARE @SumDAR DECIMAL
	DECLARE @Original DECIMAL

	SELECT @Original = m.original FROM master m WHERE m.number = @AccountId
	SELECT @SumDA = ISNULL(SUM(da.totalpaid),0) FROM payhistory da WHERE da.number = @AccountId AND da.batchtype = 'DA'
	SELECT @SumDAR = ISNULL(SUM(dar.totalpaid),0) FROM payhistory dar WHERE dar.number = @AccountId AND dar.batchtype = 'DAR'

	RETURN @Original - @SumDA + @SumDAR
END

GO
