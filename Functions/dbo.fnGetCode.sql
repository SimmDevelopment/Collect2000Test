SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnGetCode](@input VARCHAR(255))
RETURNS VARCHAR(255)
AS BEGIN
	DECLARE @pos INTEGER;

	IF @input IS NULL BEGIN
		RETURN NULL;
	END;

	SET @pos = CHARINDEX(' - ', @input);
	IF @pos = 0 BEGIN
		RETURN @input;
	END;
	SET @input = SUBSTRING(@input, 1, @pos);
	RETURN @input;
END


GO
