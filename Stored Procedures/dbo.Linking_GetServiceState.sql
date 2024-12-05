SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_GetServiceState]
AS
DECLARE @JobID UNIQUEIDENTIFIER;

DECLARE @Version VARCHAR(25);
DECLARE @SQL NVARCHAR(2000);

SET @Version = CAST(SERVERPROPERTY('productversion') AS VARCHAR(25));

SELECT TOP 1 @JobID = [sysjobs].[job_id]
FROM [msdb].[dbo].[sysjobs] AS [sysjobs]
WHERE [sysjobs].[name] = 'Latitude Linking Service (' + DB_NAME() + ')';

IF @JobID IS NULL BEGIN
	RETURN 0;
END;

IF @Version LIKE '8.%' -- SQL Server 2000
	SET @SQL = 'SELECT [sysjobs].[job_id] AS [JobID],
	[sysjobsteps].[step_id] AS [StepID],
	[sysjobsteps].[command] AS [Command],
	[sysjobschedules].[schedule_id] AS [ScheduleID],
	[sysjobschedules].[enabled] AS [Enabled],
	[sysjobschedules].[freq_subday_interval] AS [Minutes],
	[sysjobschedules].[active_start_time] AS [StartTime],
	[sysjobschedules].[active_end_time] AS [EndTime]
FROM [msdb].[dbo].[sysjobs] AS [sysjobs]
INNER JOIN [msdb].[dbo].[sysjobsteps] AS [sysjobsteps]
ON [sysjobs].[job_id] = [sysjobsteps].[job_id]
AND [sysjobs].[start_step_id] = [sysjobsteps].[step_id]
INNER JOIN [msdb].[dbo].[sysjobschedules] AS [sysjobschedules]
ON [sysjobs].[job_id] = [sysjobschedules].[job_id]
WHERE [sysjobs].[job_id] = @JobID;';
ELSE -- SQL Server 2005
	SET @SQL = 'SELECT [sysjobs].[job_id] AS [JobID],
	[sysjobsteps].[step_id] AS [StepID],
	[sysjobsteps].[command] AS [Command],
	[sysschedules].[schedule_id] AS [ScheduleID],
	[sysschedules].[enabled] AS [Enabled],
	[sysschedules].[freq_subday_interval] AS [Minutes],
	[sysschedules].[active_start_time] AS [StartTime],
	[sysschedules].[active_end_time] AS [EndTime]
FROM [msdb].[dbo].[sysjobs] AS [sysjobs]
INNER JOIN [msdb].[dbo].[sysjobsteps] AS [sysjobsteps]
ON [sysjobs].[job_id] = [sysjobsteps].[job_id]
AND [sysjobs].[start_step_id] = [sysjobsteps].[step_id]
INNER JOIN [msdb].[dbo].[sysjobschedules] AS [sysjobschedules]
ON [sysjobs].[job_id] = [sysjobschedules].[job_id]
INNER JOIN [msdb].[dbo].[sysschedules] AS [sysschedules]
ON [sysjobschedules].[schedule_id] = [sysschedules].[schedule_id]
WHERE [sysjobs].[job_id] = @JobID;';

EXEC sp_executesql @SQL, N'@JobID UNIQUEIDENTIFIER', @JobID = @JobID;

RETURN 0;


GO
