SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*  AIM_dbo.AIM_UpdateJob     */
CREATE procedure [dbo].[AIM_UpdateJob]
	@jobid int,
	@jobexecutiontypeid int,
	@jobstatusid int,
	@scheduleid int,
	@scheduleddatetime datetime = null,
	@author varchar(50),
	@description varchar(256),
	@jobpriorityid int,
	@executionwindow int,
	@endpoint varchar(2048),
	@context text	
AS


if (@jobid > 0)
	begin
		update AIM_Job
		set jobexecutiontypeid = @jobexecutiontypeid,
			jobstatusid = @jobstatusid,
			scheduleid = @scheduleid,
			scheduleddatetime = @scheduleddatetime,
			author = @author,
			description = @description,
			jobpriorityid = @jobpriorityid,
			executionwindow = @executionwindow,
			endpoint = @endpoint,
			context = @context
		where jobid = @jobid
	end
else
	begin
		insert into AIM_Job(jobexecutiontypeid, jobstatusid, scheduleid, scheduleddatetime, author, description, jobpriorityid, executionwindow, endpoint, context)
		values(@jobexecutiontypeid, @jobstatusid, @scheduleid, @scheduleddatetime, @author, @description, @jobpriorityid, @executionwindow, @endpoint, @context)
		select @jobid = @@identity
	end
	
select @jobid as 'jobid'


GO
