SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[FormatIBMNumeric](@Amount money, @len int)  
RETURNS varchar(300)  AS  
BEGIN 
	DECLARE @moneyInt int
	DECLARE @lastDigit char
	SET @moneyInt = CONVERT(int, ABS(@Amount) * 100)

	SET @lastDigit = RIGHT(CONVERT(varchar, @moneyInt), 1)

	RETURN dbo.fnLPad(LEFT(@moneyInt, LEN(@moneyInt) - 1) +
	CASE WHEN @Amount >= 0 THEN
		CASE  @lastDigit 
			WHEN '0' THEN '{'
			ELSE CHAR(ASCII('A') + CONVERT(int, @lastDigit) - 1)
			END
		ELSE CASE  @lastDigit
			WHEN '0' THEN '}'
			ELSE CHAR(ASCII('J') + CONVERT(int, @lastDigit) - 1)
		END
	END, @len, 0)
END







GO
