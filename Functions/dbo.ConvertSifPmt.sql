SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   FUNCTION [dbo].[ConvertSifPmt] (@SifPmt VARCHAR(30))
RETURNS @Result TABLE (
	[AmountDue] MONEY NULL,
	[DateDue] DATETIME NULL
)
AS BEGIN
	DECLARE @Pos INTEGER;
	DECLARE @Temp VARCHAR(30);
	DECLARE @AmountDue MONEY;
	DECLARE @DateDue DATETIME;
	IF @SifPmt LIKE '% due by %/%/%' BEGIN
		SET @Pos = CHARINDEX(' due by ', @SifPmt);
		IF @Pos > 0 BEGIN
			SET @Temp = SUBSTRING(@SifPmt, 1, @Pos - 1);
			SET @Temp = [dbo].[StripNonDigits](@Temp);
			IF LEN(@Temp) > 0 BEGIN
				SET @AmountDue = CAST(@Temp AS MONEY);
				SET @AmountDue = @AmountDue / 100;
				SET @Temp = SUBSTRING(@SifPmt, @Pos + 8, 30);
				IF ISDATE(@Temp) = 1 BEGIN
					SET @DateDue = CAST(@Temp AS DATETIME);
				END;
			END;
		END;
	END;
	INSERT INTO @Result ([AmountDue], [DateDue])
	VALUES (@AmountDue, @DateDue);
	RETURN;
END



GO
