SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[CleanSoundEx] (@input VARCHAR(250))
RETURNS CHAR(4)
WITH SCHEMABINDING
AS BEGIN
	IF @input IS NULL OR LEN(@input) = 0 BEGIN
		RETURN '';
	END
	DECLARE @temp VARCHAR(250);
	DECLARE @pos INTEGER;
	DECLARE @char CHAR(1);
	SET @pos = 1;
	SET @temp = '';
	WHILE @pos < LEN(@input) BEGIN
		SET @char = SUBSTRING(@input, @pos, 1);
		IF @char BETWEEN 'A' AND 'Z' OR @char BETWEEN 'a' AND 'z' BEGIN
			SET @temp = @temp + @char;
		END;
		SET @pos = @pos + 1;
	END;
	RETURN SOUNDEX(@temp);
END

GO
