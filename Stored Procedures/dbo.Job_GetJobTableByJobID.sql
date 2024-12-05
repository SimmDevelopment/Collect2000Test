SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Job_GetJobTableByJobID]
	@jobid int
AS


select *
from Job
where ID = @jobid

GO
