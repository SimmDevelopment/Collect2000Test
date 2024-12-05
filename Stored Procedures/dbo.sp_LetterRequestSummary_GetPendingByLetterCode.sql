SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRequestSummary_GetPendingByLetterCode*/
CREATE Procedure [dbo].[sp_LetterRequestSummary_GetPendingByLetterCode]
	@ThroughDate datetime
AS

SELECT LR.LetterID, LR.LetterCode, L.Description, COUNT(LR.LetterCode) AS PendingAmount
FROM LetterRequest LR
JOIN Letter L ON LR.LetterID = L.LetterID
WHERE DateRequested <= @ThroughDate AND (DateProcessed IS NULL OR DateProcessed = '1/1/1753 12:00:00')
AND LR.Deleted = 0 AND LR.AddEditMode = 0 AND LR.Suspend = 0 AND LR.Edited = 0
GROUP BY LR.LetterCode, LR.LetterID, L.Description
ORDER BY LR.LetterCode

GO
