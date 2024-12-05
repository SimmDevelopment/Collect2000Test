SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   FUNCTION [dbo].[fnExtractIDs] (@input IMAGE, @littleEndian BIT)
RETURNS @Results TABLE (
	[rowid] INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	[value] INTEGER NOT NULL
)
AS BEGIN
	DECLARE @len INTEGER;
	DECLARE @pos INTEGER;
	DECLARE @chunk BINARY(4);
	DECLARE @value INTEGER;

	IF @input IS NULL BEGIN
		RETURN;
	END;

	SET @len = DATALENGTH(@input);
	IF @len = 0 BEGIN
		RETURN;
	END;

	SET @len = @len - (@len % 4);

	SET @pos = 1;
	WHILE @pos < @len BEGIN
		SET @chunk = SUBSTRING(@input, @pos, 4);
		IF @littleEndian = 1 BEGIN
			SET @chunk = SUBSTRING(@chunk, 4, 1) + SUBSTRING(@chunk, 3, 1) + SUBSTRING(@chunk, 2, 1) + SUBSTRING(@chunk, 1, 1);
		END;
		SET @value = CAST(@chunk AS INTEGER);
		INSERT INTO @Results ([value])
		VALUES (@value);
		SET @pos = @pos + 4;
	END;	
	RETURN;
END





GO
