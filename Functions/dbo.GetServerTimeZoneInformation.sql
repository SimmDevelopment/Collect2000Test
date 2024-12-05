SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  FUNCTION [dbo].[GetServerTimeZoneInformation] ()
RETURNS @TZInfo TABLE (
	[Name] VARCHAR(250) NULL,
	[ActiveBias] INTEGER NULL,
	[Bias] INTEGER NULL,
	[DaylightBias] INTEGER NULL,
	[IsDST] BIT NULL
)
AS BEGIN
	DECLARE @ActiveTimeBias INTEGER;
	DECLARE @Bias INTEGER;
	DECLARE @DaylightBias INTEGER;
	DECLARE @DaylightName VARCHAR(260);
	DECLARE @StandardBias INTEGER;
	DECLARE @StandardName VARCHAR(260);
	DECLARE @IsDST BIT;

	EXEC master..xp_instance_regread @rootkey = 'HKEY_LOCAL_MACHINE',
		@key = 'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
		@value_name = 'ActiveTimeBias',
		@value = @ActiveTimeBias OUTPUT;

	IF @ActiveTimeBias IS NULL BEGIN
		INSERT INTO @TZInfo ([Name])
		VALUES ('Unknown');
		RETURN;
	END;

	EXEC master..xp_instance_regread @rootkey = 'HKEY_LOCAL_MACHINE',
		@key = 'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
		@value_name = 'Bias',
		@value = @Bias OUTPUT;

	EXEC master..xp_instance_regread @rootkey = 'HKEY_LOCAL_MACHINE',
		@key = 'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
		@value_name = 'DaylightBias',
		@value = @DaylightBias OUTPUT;

	EXEC master..xp_instance_regread @rootkey = 'HKEY_LOCAL_MACHINE',
		@key = 'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
		@value_name = 'DaylightName',
		@value = @DaylightName OUTPUT;

	EXEC master..xp_instance_regread @rootkey = 'HKEY_LOCAL_MACHINE',
		@key = 'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
		@value_name = 'StandardBias',
		@value = @StandardBias OUTPUT;

	EXEC master..xp_instance_regread @rootkey = 'HKEY_LOCAL_MACHINE',
		@key = 'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
		@value_name = 'StandardName',
		@value = @StandardName OUTPUT;

	IF @Bias <> 0 AND @ActiveTimeBias = @Bias + @DaylightBias
		SET @IsDST = 1;
	ELSE
		SET @IsDST = 0;

	INSERT INTO @TZInfo ([Name], [ActiveBias], [Bias], [DaylightBias], [IsDST])
	VALUES (CASE @IsDST WHEN 1 THEN @DaylightName ELSE @StandardName END, @ActiveTimeBias, @Bias, @DaylightBias, @IsDST);

	RETURN;
END


GO
