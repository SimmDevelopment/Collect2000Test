SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnFormatPhone](@Number VARCHAR(20), @Extension VARCHAR(10))
RETURNS VARCHAR(30)
AS
BEGIN
	DECLARE @Formatted VARCHAR(30);
	IF @Number IS NULL OR @Number = '' BEGIN
		RETURN '(000) 000-0000';
	END;
	SET @Number = [dbo].[StripNonDigits](@Number);
	IF LEN(@Number) = 7 BEGIN
		SET @Formatted = '(000) ' + SUBSTRING(@Number, 1, 3) + '-' + SUBSTRING(@Number, 4, 4);
	END;
	ELSE IF LEN(@Number) = 10 BEGIN
		SET @Formatted = '(' + SUBSTRING(@Number, 1, 3) + ') ' + SUBSTRING(@Number, 4, 3) + '-' + SUBSTRING(@Number, 7, 4);
	END;
	ELSE IF LEN(@Number) = 11 AND @Number LIKE '1%' BEGIN
		SET @Formatted = '(' + SUBSTRING(@Number, 2, 3) + ') ' + SUBSTRING(@Number, 5, 3) + '-' + SUBSTRING(@Number, 8, 4);
	END;
	ELSE BEGIN
		SET @Formatted = @Number;
	END;

	IF @Extension IS NOT NULL AND LEN(LTRIM(RTRIM(@Extension))) > 0 BEGIN
		SET @Formatted = @Formatted + ' ext.' + LTRIM(RTRIM(@Extension));
	END;
	RETURN @Formatted;
END

GO
