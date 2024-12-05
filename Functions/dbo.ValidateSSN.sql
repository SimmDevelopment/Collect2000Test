SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE  FUNCTION [dbo].[ValidateSSN] (@input VARCHAR(15))
RETURNS CHAR(9)
WITH SCHEMABINDING
AS BEGIN
	IF @input IS NULL OR LEN(@input) < 9 BEGIN
		RETURN NULL;
	END;

	DECLARE @temp VARCHAR(15);
	SET @temp = [dbo].[StripNonDigits](@input);

	IF NOT LEN(@temp) = 9 BEGIN
		RETURN NULL;
	END;

	IF @temp IN ('000000000', '111111111', '222222222', '333333333', '444444444', '555555555', '666666666', '777777777', '888888888', '999999999', '123456789', '098764321', '98764321', '078051120') BEGIN
		RETURN NULL;
	END;

	IF @temp LIKE '000______'
		OR @temp LIKE '___00____'
		OR @temp LIKE '_____0000'
		OR @temp LIKE '666______'
		OR @temp >= '773000000' BEGIN

		RETURN NULL;
	END;

	DECLARE @Count INTEGER;
	DECLARE @Diff INTEGER;
	DECLARE @Invalid BIT;

	SET @Invalid = 1;
	SET @Count = 2;
	WHILE @Count <= 9 AND @Invalid = 1 BEGIN
		SET @Diff = ABS(ASCII(SUBSTRING(@temp, @Count - 1, 1)) - ASCII(SUBSTRING(@temp, @Count, 1)));
		IF @Diff > 1
			SET @Invalid = 0;
		SET @Count = @Count + 1;
	END;

	IF @Invalid = 1
		RETURN NULL;

	RETURN @temp;
END




GO
