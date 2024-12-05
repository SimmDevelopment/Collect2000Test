SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[Custom_ConvertNumberToIBMSigned](@number varchar(20),@returnlength int, @alphaforpositive int)
returns varchar(20)
AS
BEGIN

DECLARE @length int
DECLARE @numbersubstring varchar(20)
DECLARE @numberflagchar varchar
DECLARE @returnnumberstring varchar(21)

-- Remove the decimal characters and find the
-- length of the resultant
SET @returnnumberstring = REPLACE(@number,'.','')
SET @length = len(@returnnumberstring)

SET @numbersubstring = substring(@returnnumberstring,1,@length-1)
SET @numberflagchar = substring(@returnnumberstring,@length,1)

-- If we have a negative value
IF(CAST(@returnnumberstring as bigint) < 0)
BEGIN

	SET @returnnumberstring = @numbersubstring + 
	CASE   @numberflagchar
		WHEN '0' THEN '}'
		WHEN '1' THEN 'J'
		WHEN '2' THEN 'K'
		WHEN '3' THEN 'L'
		WHEN '4' THEN 'M'
		WHEN '5' THEN 'N'
		WHEN '6' THEN 'O'
		WHEN '7' THEN 'P'
		WHEN '8' THEN 'Q'
		WHEN '9' THEN 'R'
	END
	-- Remove the negative sign.
	SET @returnnumberstring = REPLACE(@returnnumberstring,'-','')
END
-- If we are to use alphas for the last character when returning a positive number.
ELSE IF(@alphaforpositive <> 0)
BEGIN

	SET @returnnumberstring = @numbersubstring + 
		CASE   @numberflagchar
			WHEN '0' THEN '{'
			WHEN '1' THEN 'A'
			WHEN '2' THEN 'B'
			WHEN '3' THEN 'C'
			WHEN '4' THEN 'D'
			WHEN '5' THEN 'E'
			WHEN '6' THEN 'F'
			WHEN '7' THEN 'G'
			WHEN '8' THEN 'H'
			WHEN '9' THEN 'I'
		END
END
-- Using the given length set the requested value to the 
-- right most characters...this could result in truncation of 
-- most significant digits.
SET @returnnumberstring = RIGHT(@returnnumberstring,@returnlength)

-- While we have a string that is smaller then the requested 
-- length prepend zeroes.
WHILE(LEN(@returnnumberstring) < @returnlength)
BEGIN
	SET @returnnumberstring = '0' + @returnnumberstring
END
RETURN @returnnumberstring

END


GO
