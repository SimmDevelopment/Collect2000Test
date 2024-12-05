SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE    FUNCTION [dbo].[fnExtractIDs16] (@input IMAGE, @littleEndian BIT)
RETURNS @Results TABLE (
	[rowid] INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	[value] SMALLINT NOT NULL
)
AS BEGIN
	DECLARE @len INTEGER;
	DECLARE @pos INTEGER;
	DECLARE @chunk BINARY(2);
	DECLARE @value INTEGER;

	IF @input IS NULL BEGIN
		RETURN;
	END;

	SET @len = DATALENGTH(@input);
	IF @len = 0 BEGIN
		RETURN;
	END;

	SET @len = @len - (@len % 2);

	SET @pos = 1;
	WHILE @pos < @len BEGIN
		SET @chunk = SUBSTRING(@input, @pos, 2);
		IF @littleEndian = 1 BEGIN
			SET @chunk = SUBSTRING(@chunk, 2, 1) + SUBSTRING(@chunk, 1, 1);
		END;
		SET @value = CAST(@chunk AS INTEGER);
		INSERT INTO @Results ([value])
		VALUES (@value);
		SET @pos = @pos + 2;
	END;	
	RETURN;
END






GO
