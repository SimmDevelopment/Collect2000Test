SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fnStripNonAscii] (@input VARCHAR(8000))
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
		IF (@ascii >= 32 AND @ascii <= 126) BEGIN
			SET @output = @output + CHAR(@ascii)
		END
		SET @pos = @pos + 1
	END

	RETURN @output
END

GO
