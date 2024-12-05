SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*  AIM_dbo.AIM_GetJobCount     */
CREATE procedure [dbo].[AIM_GetJobCount]
	@jobstatusid int
AS


select count(jobid) as 'jobcount' from AIM_Job
where jobstatusid = @jobstatusid


GO
