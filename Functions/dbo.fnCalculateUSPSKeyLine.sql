SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnCalculateUSPSKeyLine](@DebtorID INTEGER)
RETURNS VARCHAR(16)
AS BEGIN
	DECLARE @Keyline VARCHAR(16);
	DECLARE @CheckDigit CHAR(1);

	SET @Keyline = CAST(@DebtorID AS VARCHAR(12));

	IF LEN(@KeyLine) < 11 BEGIN
		SET @KeyLine = REPLICATE('0', 11 - LEN(@KeyLine)) + @Keyline;
	END

	SET @Keyline = 'LAT/' + @Keyline;
	SET @CheckDigit = dbo.fnCalculateUSPSCheckDigit(@Keyline);
	SET @Keyline = @Keyline + @CheckDigit;

	RETURN @Keyline;
END

GO
