SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*  AIM_dbo.AIM_UpdateJobRun     */
CREATE procedure [dbo].[AIM_UpdateJobRun]
	@jobrunid int,
	@jobid int,
	@jobstatusid int,
	@scheduleddatetime datetime = null,
	@starteddatetime datetime = null,
	@completeddatetime datetime = null,
	@results varchar(2048)
AS


if (@jobrunid > 0)
	begin
		update AIM_JobRun
		set jobid = @jobid,
			jobstatusid = @jobstatusid,
			scheduleddatetime = @scheduleddatetime,
			starteddatetime = @starteddatetime,
			completeddatetime = @completeddatetime,
			results = @results
		where jobrunid = @jobrunid
	end
else
	begin
		insert into AIM_JobRun(jobid, jobstatusid, scheduleddatetime, starteddatetime, completeddatetime, results)
		values(@jobid, @jobstatusid, @scheduleddatetime, @starteddatetime, @completeddatetime, @results)
		select @jobrunid = @@identity
	end
select @jobrunid as 'jobrunid'


GO
