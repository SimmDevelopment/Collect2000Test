SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CalculateInterest](@Principal MONEY, @InterestRate REAL, @LastDate DATETIME, @CurrentDate DATETIME)
RETURNS MONEY
AS BEGIN
	IF @Principal IS NULL OR @InterestRate IS NULL OR @LastDate IS NULL OR @CurrentDate IS NULL
		RETURN 0;
	IF @Principal <= 0
		RETURN 0;
	
	DECLARE @Days INTEGER;
	DECLARE @DailyRate REAL;
	DECLARE @NewInterest MONEY;

	SET @Days = DATEDIFF(DAY, @LastDate, @CurrentDate);
	SET @DailyRate = ROUND(@Principal * (@InterestRate / 100.0 / 365.0), 2, 1)
	SET @NewInterest = @DailyRate * @Days;
	RETURN @NewInterest;
END
GO
