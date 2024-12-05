SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[fnLPad](@val varchar(20), @len int, @padChar char)  
RETURNS varchar(20) 

AS  
BEGIN 
	IF LEN(@val) >= @len RETURN @val
	ELSE
		WHILE LEN(@val) < @len
		BEGIN
			SET @val = @padChar + @val
		END 	

	RETURN @val
END

GO
