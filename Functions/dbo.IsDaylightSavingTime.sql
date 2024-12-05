SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[IsDaylightSavingTime](@Local DATETIME)
RETURNS BIT
AS BEGIN
	DECLARE @hr INTEGER;
	DECLARE @obj INTEGER;
	DECLARE @IsDST BIT;

	IF @Local IS NULL
		RETURN NULL;

	EXEC @hr = sp_OACreate 'GSSITime.TimeZoneConverter', @obj OUTPUT, 1;
	IF @hr = 0 BEGIN
		SET @IsDST = 0;
		EXEC sp_OAMethod @obj, 'IsDaylightSavingTime', @IsDST OUTPUT, @Local;
		IF @hr != 0
			SET @IsDST = 0;
		EXEC sp_OADestroy @obj;
	END;
	RETURN @IsDST;
END

GO
