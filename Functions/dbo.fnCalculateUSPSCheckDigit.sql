SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnCalculateUSPSCheckDigit](@Input VARCHAR(15))
RETURNS CHAR(1)
AS BEGIN
	DECLARE @Count INTEGER;
	DECLARE @Char CHAR(1);
	DECLARE @Value INTEGER;
	DECLARE @ValueChar VARCHAR(2);
	DECLARE @ValueCount INTEGER;
	DECLARE @Tally INTEGER;

	IF @Input IS NULL
		RETURN '0';
	
	SET @Input = UPPER(@Input);
	
	SET @Count = 1;
	SET @Tally = 0;
	WHILE @Count <= LEN(@Input) BEGIN
		SET @Char = SUBSTRING(@Input, @Count, 1);
		IF ISNUMERIC(@Char) = 1 BEGIN
			SET @Value = CAST(@Char AS INTEGER);
		END;
		ELSE BEGIN
			IF @Char BETWEEN 'A' AND 'O'
				SET @Value = ASCII(@Char) - 64;
			ELSE IF @Char BETWEEN 'P' AND 'Z'
				SET @Value = ASCII(@Char) - 80;
			ELSE IF @Char = '/'
				SET @Value = 15;
			ELSE
				SET @Value = 0;
		END;
		IF @Count % 2 = 1
			SET @Value = @Value * 2;
		SET @ValueChar = CAST(@Value AS VARCHAR(2));
		SET @ValueCount = 1;
		WHILE @ValueCount <= LEN(@ValueChar) BEGIN
			SET @Tally = @Tally + CAST(SUBSTRING(@ValueChar, @ValueCount, 1) AS INTEGER);
			SET @ValueCount = @ValueCount + 1;
		END;
		SET @Count = @Count + 1;
	END;
	
	SET @Tally = @Tally % 10;
	IF @Tally != 0
		SET @Tally = 10 - @Tally;

	RETURN CAST(@Tally AS CHAR(1));
END

GO
