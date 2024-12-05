SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create     procedure [dbo].[AIM_ExecuteSqlAsJob]
(
	@sqlString varchar(2000)
	,@database varchar(50)
	,@server varchar(50)
)
as
begin
	

	exec msdb.dbo.sp_add_job  @job_name = 'Execute Sql Job', @delete_level = 3
	
	exec msdb.dbo.sp_add_jobstep @job_name = 'Execute Sql Job',
	   @step_name = 'Execute Sql',
	   @subsystem = 'TSQL',
	   @command = @sqlString, 
	   @retry_attempts = 5,
	   @retry_interval = 5,
	   @database_name = @database

	exec msdb.dbo.sp_add_jobserver @job_name = 'Execute Sql Job', @server_name = @server
	
	exec msdb.dbo.sp_start_job @job_name = 'Execute Sql Job'
end




GO
