SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fnAlphaWithSpacesOnly] (@input VARCHAR(8000))
RETURNS VARCHAR(8000)
WITH SCHEMABINDING
AS BEGIN
	IF @input IS NULL BEGIN
		RETURN NULL
	END

	DECLARE @pos INTEGER
	DECLARE @output VARCHAR(8000)
	DECLARE @ascii INTEGER

	SET @pos = 1
	SET @output = ''

	WHILE @pos <= LEN(@input) BEGIN
		SET @ascii = ASCII(SUBSTRING(@input, @pos, 1))
		IF (@ascii >= 65 AND @ascii <= 90) OR (@ascii >= 97 AND @ascii <= 122 OR @ascii = 32) BEGIN
			SET @output = @output + CHAR(@ascii)
		END
		SET @pos = @pos + 1
	END

	RETURN @output
END

GO
