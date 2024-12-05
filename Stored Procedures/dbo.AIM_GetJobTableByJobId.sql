SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*  AIM_dbo.AIM_GetJobTableByJobId     */
CREATE procedure [dbo].[AIM_GetJobTableByJobId]
	@jobid int
AS


select jobid, 
	   jobexecutiontypeid, 
	   jobstatusid, 
	   scheduleid, 
	   scheduleddatetime, 
	   author, 
	   description, 
	   jobpriorityid, 
	   executionwindow, 
	   endpoint, 
	   context
from AIM_Job
where jobid = @jobid


GO
