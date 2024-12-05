SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Linking_ConfigureService] @StartTime DATETIME, @EndTime DATETIME, @Interval INTEGER, @BatchSize INTEGER
AS
SET NOCOUNT ON;
DECLARE @JobID UNIQUEIDENTIFIER;
DECLARE @StepID INTEGER;
DECLARE @ScheduleID INTEGER;
DECLARE @JobName VARCHAR(255);
DECLARE @Command VARCHAR(500);
DECLARE @Database SYSNAME;
DECLARE @StartDateInteger INTEGER;
DECLARE @StartTimeInteger INTEGER;
DECLARE @EndTimeInteger INTEGER;

SET @JobName = 'Latitude Linking Service (' + DB_NAME() + ')';
SET @Command = 'EXEC [dbo].[Linking_LinkAccounts] @BatchSize = ' + CAST(@BatchSize AS VARCHAR) + ';';
SET @Database = DB_NAME();
SET @StartDateInteger = CAST(CONVERT(VARCHAR(8), GETDATE(), 112) AS INTEGER);
SET @StartTimeInteger = CAST(REPLACE(CONVERT(VARCHAR(8), @StartTime, 8), ':', '') AS INTEGER);
SET @EndTimeInteger = CAST(REPLACE(CONVERT(VARCHAR(8), @EndTime, 8), ':', '') AS INTEGER);

SELECT TOP 1 @JobID = [sysjobs].[job_id]
FROM [msdb].[dbo].[sysjobs] AS [sysjobs]
WHERE [sysjobs].[name] = 'Latitude Linking Service (' + DB_NAME() + ')';

IF @JobID IS NULL BEGIN
	BEGIN TRANSACTION;

	EXEC [msdb].[dbo].[sp_add_job] @job_name = @JobName,
		@enabled = 0,
		@description = 'Do not modify outside of Latitude LinkConsole',
		@owner_login_name = 'sa',
		@job_id = @JobID OUTPUT;

	EXEC [msdb].[dbo].[sp_add_jobstep] @job_id = @JobID,
		@step_name = 'Link Accounts',
		@subsystem = 'TSQL',
		@command = @Command,
		@database_name = @Database;

	EXEC [msdb].[dbo].[sp_add_jobschedule] @job_id = @JobID,
		@name = 'Linking Schedule',
		@enabled = 0,
		@freq_type = 4,
		@freq_interval = 1,
		@freq_subday_type = 4,
		@freq_subday_interval = @Interval,
		@active_start_date = @StartDateInteger,
		@active_start_time = @StartTimeInteger,
		@active_end_time = @EndTimeInteger;

	EXEC [msdb].[dbo].[sp_add_jobserver] @job_id = @JobID,
		@server_name = N'(LOCAL)';

	COMMIT TRANSACTION;
END;
ELSE BEGIN
	BEGIN TRANSACTION;

	SELECT @StepID = [sysjobsteps].[step_id]
	FROM [msdb].[dbo].[sysjobs] AS [sysjobs]
	INNER JOIN [msdb].[dbo].[sysjobsteps] AS [sysjobsteps]
	ON [sysjobs].[job_id] = [sysjobsteps].[job_id]
	AND [sysjobs].[start_step_id] = [sysjobsteps].[step_id];

	IF @StepID IS NULL BEGIN
		EXEC [msdb].[dbo].[sp_add_jobstep] @job_id = @JobID,
			@step_name = 'Link Accounts',
			@subsystem = 'TSQL',
			@command = @Command,
			@database_name = @Database;
	END;
	ELSE BEGIN
		EXEC [msdb].[dbo].[sp_update_jobstep] @job_id = @JobID,
			@step_id = @StepID,
			@subsystem = 'TSQL',
			@command = @Command,
			@database_name = @Database;
	END;

	SELECT TOP 1 @ScheduleID = [sysjobschedules].[schedule_id]
	FROM [msdb].[dbo].[sysjobs] AS [sysjobs]
	INNER JOIN [msdb].[dbo].[sysjobschedules] AS [sysjobschedules]
	ON [sysjobs].[job_id] = [sysjobschedules].[job_id];

	IF @ScheduleID IS NULL BEGIN
		EXEC [msdb].[dbo].[sp_add_jobschedule] @job_id = @JobID,
			@name = 'Linking Schedule',
			@enabled = 0,
			@freq_type = 4,
			@freq_interval = 1,
			@freq_subday_type = 4,
			@freq_subday_interval = @Interval,
			@active_start_date = @StartDateInteger,
			@active_start_time = @StartTimeInteger,
			@active_end_time = @EndTimeInteger;
	END;
	ELSE BEGIN
		EXEC [msdb].[dbo].[sp_update_jobschedule] @job_id = @JobID,
			@name = 'Linking Schedule',
			@freq_type = 4,
			@freq_interval = 1,
			@freq_subday_type = 4,
			@freq_subday_interval = @Interval,
			@active_start_date = @StartDateInteger,
			@active_start_time = @StartTimeInteger,
			@active_end_time = @EndTimeInteger;
	END;

	COMMIT TRANSACTION;
END;

RETURN 0;

GO
