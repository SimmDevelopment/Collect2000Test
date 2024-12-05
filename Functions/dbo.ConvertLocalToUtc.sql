SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ConvertLocalToUtc](@Local DATETIME)
RETURNS DATETIME
AS BEGIN
	DECLARE @hr INTEGER;
	DECLARE @obj INTEGER;
	DECLARE @UTC DATETIME;

	IF @Local IS NULL
		RETURN NULL;

	EXEC @hr = sp_OACreate 'GSSITime.TimeZoneConverter', @obj OUTPUT, 1;
	IF @hr = 0 BEGIN
		SET @UTC = 0;
		EXEC sp_OAMethod @obj, 'ConvertLocalToUtc', @UTC OUTPUT, @Local;
		IF @hr != 0
			SET @UTC = NULL;
		EXEC sp_OADestroy @obj;
	END;
	RETURN @UTC;
END

GO
