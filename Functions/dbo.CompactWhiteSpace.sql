SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[CompactWhiteSpace] (@input VARCHAR(8000))
RETURNS VARCHAR(8000)
WITH SCHEMABINDING
AS BEGIN

	IF @input = '' OR @input IS NULL BEGIN
		RETURN @input
	END

	DECLARE @output VARCHAR(8000)
	DECLARE @pos INTEGER
	DECLARE @ascii INTEGER
	DECLARE @ws BIT

	SET @input = LTRIM(RTRIM(@input))
	SET @output = ''
	SET @pos = 1
	SET @ws = 0
	WHILE @pos <= LEN(@input) BEGIN
		SET @ascii = ASCII(SUBSTRING(@input, @pos, 1))
		IF @ascii BETWEEN 48 AND 57 OR @ascii BETWEEN 65 AND 90 OR @ascii BETWEEN 96 AND 122 BEGIN
			SET @ws = 0
			SET @output = @output + CHAR(@ascii)
		END
		ELSE BEGIN
			IF @ws = 0 BEGIN
				SET @output = @output + CHAR(@ascii)
			END
			SET @ws = 1
		END
		SET @pos = @pos + 1
	END

	RETURN @output
END

GO
