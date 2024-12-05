SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ConvertUtcToLocal](@UTC DATETIME)
RETURNS DATETIME
AS BEGIN
	DECLARE @hr INTEGER;
	DECLARE @obj INTEGER;
	DECLARE @Local DATETIME;

	IF @UTC IS NULL
		RETURN NULL;

	EXEC @hr = sp_OACreate 'GSSITime.TimeZoneConverter', @obj OUTPUT, 1;
	IF @hr = 0 BEGIN
		SET @Local = 0;
		EXEC sp_OAMethod @obj, 'ConvertUtcToLocal', @Local OUTPUT, @UTC;
		IF @hr != 0
			SET @Local = NULL;
		EXEC sp_OADestroy @obj;
	END;
	RETURN @Local;
END

GO
