SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_SetServiceState] @Enabled BIT
AS
SET NOCOUNT ON;
DECLARE @JobName SYSNAME;
DECLARE @JobID UNIQUEIDENTIFIER
DECLARE @ScheduleID INTEGER;
DECLARE @Version INTEGER;
DECLARE @SQL NVARCHAR(2000);

SET @JobName = 'Latitude Linking Service (' + DB_NAME() + ')';
SET @Version = CAST(ISNULL(PARSENAME(CAST(SERVERPROPERTY('productversion') AS VARCHAR(25)), 4), ISNULL(PARSENAME(CAST(SERVERPROPERTY('productversion') AS VARCHAR(25)), 3), 8)) AS INTEGER);

IF @Version = 8 BEGIN -- SQL Server 2000
	SET @SQL = '
		SELECT TOP 1 @JobID = [sysjobs].[job_id],
			@ScheduleID = [sysjobschedules].[schedule_id]
		FROM [msdb].[dbo].[sysjobs] AS [sysjobs]
		INNER JOIN [msdb].[dbo].[sysjobsteps] AS [sysjobsteps]
		ON [sysjobs].[job_id] = [sysjobsteps].[job_id]
		AND [sysjobs].[start_step_id] = [sysjobsteps].[step_id]
		INNER JOIN [msdb].[dbo].[sysjobschedules] AS [sysjobschedules]
		ON [sysjobs].[job_id] = [sysjobschedules].[job_id]
		WHERE [sysjobs].[name] = @JobName;';
END
ELSE BEGIN
	SET @SQL = '
		SELECT TOP 1 @JobID = [sysjobs].[job_id],
			@ScheduleID = [sysschedules].[schedule_id]
		FROM [msdb].[dbo].[sysjobs] AS [sysjobs]
		INNER JOIN [msdb].[dbo].[sysjobsteps] AS [sysjobsteps]
		ON [sysjobs].[job_id] = [sysjobsteps].[job_id]
		AND [sysjobs].[start_step_id] = [sysjobsteps].[step_id]
		INNER JOIN [msdb].[dbo].[sysjobschedules] AS [sysjobschedules]
		ON [sysjobs].[job_id] = [sysjobschedules].[job_id]
		INNER JOIN [msdb].[dbo].[sysschedules] AS [sysschedules]
		ON [sysjobschedules].[schedule_id] = [sysschedules].[schedule_id]
		WHERE [sysjobs].[name] = @JobName;';
END;

EXEC [dbo].[sp_executesql] @stmt = @SQL,
	@parameters = N'@JobName SYSNAME, @JobID UNIQUEIDENTIFIER OUTPUT, @ScheduleID INTEGER OUTPUT',
	@JobName = @JobName,
	@JobID = @JobID OUTPUT,
	@ScheduleID = @ScheduleID OUTPUT;

IF @JobID IS NULL BEGIN
	RAISERROR('Linking service has not been configured for this database.', 16, 1);
	RETURN 1;
END;

BEGIN TRANSACTION;

EXEC [msdb].[dbo].[sp_update_job] @job_id = @JobID, @enabled = @Enabled;

IF @Version = 8 -- SQL Server 2000
	SET @SQL ='EXEC [msdb].[dbo].[sp_update_jobschedule] @job_id = @JobID, @name = ''Linking Schedule'', @enabled = @Enabled'
ELSE
	SET	@SQL ='EXEC [msdb].[dbo].[sp_update_schedule] @schedule_id = @ScheduleID, @enabled = @Enabled'

EXEC sp_executesql @SQL, N'@JobID UNIQUEIDENTIFIER, @ScheduleID INTEGER, @Enabled BIT', @JobID = @JobID, @ScheduleID = @ScheduleID, @Enabled = @Enabled;

IF @Enabled = 1
	EXEC [msdb].[dbo].[sp_start_job] @job_id = @JobID;
ELSE
	EXEC [msdb].[dbo].[sp_stop_job] @job_id = @JobID;

COMMIT TRANSACTION;

RETURN 0;


GO
