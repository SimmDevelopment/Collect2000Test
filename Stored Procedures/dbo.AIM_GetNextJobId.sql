SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*  AIM_dbo.AIM_GetNextJobId     */
CREATE procedure [dbo].[AIM_GetNextJobId]
	@jobsensitivityinseconds int
AS


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
declare @nextjobid int
select @nextjobid = 0
/* Get the next job to run */
select top 1 @nextjobid = j.jobid
from AIM_Job j
where getdate() between j.scheduleddatetime
and dateadd(ss, @jobsensitivityinseconds, j.scheduleddatetime)
and j.jobstatusid = 1 /*Pending*/
order by j.jobpriorityid, j.jobid

if (@nextjobid = 0)
begin
	select top 1 @nextjobid = j.jobid
	from AIM_Job j
	where j.scheduleddatetime < getdate()
	and j.jobstatusid = 1 /*Pending*/
	order by j.scheduleddatetime asc, j.jobpriorityid, j.jobid
end

if (@nextjobid <> 0)
begin
	update AIM_Job
	set jobstatusid = 2 /* Executing */
	where jobid = @nextjobid
end

COMMIT TRANSACTION

select @nextjobid as 'nextjobid'


GO
