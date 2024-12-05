SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Server_GetServerTimeZoneInfo]
AS
SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#reg_TZ_info') IS NOT NULL
	DROP TABLE #reg_TZ_info;

CREATE TABLE #reg_TZ_info (
	[Value] SYSNAME NOT NULL,
	[Data] BINARY(16) NOT NULL
);

DECLARE @ActiveTimeBias INTEGER;
DECLARE @Bias INTEGER;
DECLARE @DaylightBias INTEGER;
DECLARE @DaylightStart BINARY(16);
DECLARE @DaylightName VARCHAR(260);
DECLARE @StandardBias INTEGER;
DECLARE @StandardStart BINARY(16);
DECLARE @StandardName VARCHAR(260);

EXEC master..xp_instance_regread @rootkey = 'HKEY_LOCAL_MACHINE',
	@key = 'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
	@value_name = 'ActiveTimeBias',
	@value = @ActiveTimeBias OUTPUT;

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

INSERT INTO #reg_TZ_info ([Value], [Data])
EXEC master..xp_instance_regread @rootkey = 'HKEY_LOCAL_MACHINE',
	@key = 'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
	@value = 'StandardStart';

INSERT INTO #reg_TZ_info ([Value], [Data])
EXEC master..xp_instance_regread @rootkey = 'HKEY_LOCAL_MACHINE',
	@key = 'SYSTEM\CurrentControlSet\Control\TimeZoneInformation',
	@value = 'DaylightStart';

SELECT @StandardStart = [Data]
FROM #reg_TZ_info
WHERE [Value] = 'StandardStart';

SELECT @DaylightStart = [Data]
FROM #reg_TZ_info
WHERE [Value] = 'DaylightStart';

SELECT @ActiveTimeBias AS [ActiveTimeBias],
	@Bias AS [Bias],
	@DaylightBias AS [DaylightBias],
	@DaylightStart AS [DaylightStart],
	@DaylightName AS [DaylightName],
	@StandardBias AS [StandardBias],
	@StandardStart AS [StandardStart],
	@StandardName AS [StandardName],
	GETDATE() AS [CurrentServerDate],
	GETUTCDATE() AS [CurrentUtcDate];

RETURN 0;

GO
