SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  FUNCTION [dbo].[GetCallableTimeZones] (@UTC DATETIME)
RETURNS @TimeZones TABLE (
	TimeZone INTEGER NULL,
	LocalTime DATETIME NOT NULL
)
AS BEGIN
	DECLARE @TZ TINYINT;
	DECLARE @Local DATETIME;
	DECLARE @Bias INTEGER;
	DECLARE @ActiveBias INTEGER;
	DECLARE @DSTBias INTEGER;

	EXEC master..xp_regread
	    'HKEY_LOCAL_MACHINE',
	    'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
	    'Bias',
 	   @Bias OUTPUT;
 
	EXEC master..xp_regread
	    'HKEY_LOCAL_MACHINE',
	    'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
	    'ActiveTimeBias',
	    @ActiveBias OUTPUT;

	SET @DSTBias = @Bias - @ActiveBias;
	SET @Local = DATEADD(MINUTE, -@ActiveBias, @UTC);

	IF DATEPART(HOUR, @Local) BETWEEN 8 AND 20
		INSERT INTO @TimeZones (TimeZone, LocalTime)
		VALUES (NULL, @Local);

	SET @TZ = 1;

	WHILE @TZ < 16 BEGIN
		SET @Local = DATEADD(HOUR, -@TZ, @UTC);
		IF @DSTBias != 0
			SET @Local = DATEADD(MINUTE, @DSTBias, @Local);
		IF DATEPART(HOUR, @Local) BETWEEN 8 AND 20
			INSERT INTO @TimeZones (TimeZone, LocalTime)
			VALUES (@TZ, @Local);
		SET @TZ = @TZ + 1;
	END;

	RETURN;
END



GO
