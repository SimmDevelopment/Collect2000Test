SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRequest_GetPreviousJobs*/
CREATE Procedure [dbo].[sp_LetterRequest_GetPreviousJobs]
	/* Param List */
AS

--Get the distinct JobNames over the past 10 days
SELECT DISTINCT JobName
FROM LetterRequest
WHERE DateCreated >= DATEADD(d, -10, GETDATE()) AND JobName IS NOT NULL AND JobName <> '' 
	AND LEFT(JobName, 6) <> '[Seed]' AND LEFT(JobName, 6) <> 'Manual'
ORDER BY JobName

GO
