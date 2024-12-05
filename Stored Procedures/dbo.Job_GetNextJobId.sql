SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Job_GetNextJobId]
	@jobsensitivityinseconds int,
	@nextChainedJobID int = NULL
AS


SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION

DECLARE @nextjobid INT
SELECT @nextjobid = 0

-- If we are not given a chained job then as previous.
IF(@nextChainedJobID IS NULL)
BEGIN

	SELECT TOP 1 @nextjobid = j.ID
	FROM Job j 
	WHERE getdate() BETWEEN j.NextRunDateTime
	AND dateadd(ss, @jobsensitivityinseconds, j.NextRunDateTime)
	AND j.JobStatusID = 1 /*Pending*/
	AND j.Scheduled = 1 AND j.Enabled = 1
	ORDER BY j.NextRunDateTime ASC

	IF (@nextjobid = 0)
	BEGIN
		SELECT TOP 1 @nextjobid = j.ID
		FROM Job j
		WHERE j.NextRunDateTime < getdate()
		AND j.JobStatusID = 1 /*Pending*/
		AND j.Scheduled = 1 AND j.Enabled = 1
		ORDER BY j.NextRunDateTime ASC
	END
END
-- Otherwise use the given chained job.
ELSE
BEGIN
	SET @nextjobid = @nextChainedJobID
END

IF (@nextjobid <> 0)
BEGIN
	UPDATE Job
	SET JobStatusID = 2 /*Executing*/
	,LastRunOutcome = 'Executing'
	where ID = @nextjobid
END

COMMIT TRANSACTION

SELECT @nextjobid AS 'nextjobid'

GO
