SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterReqeust_GetPendingByLetter*/
CREATE Procedure [dbo].[sp_LetterReqeust_GetPendingByLetter]
	@LetterID int,
	@ThroughDate datetime
AS

SELECT LR.*, L.Description
FROM LetterRequest LR
JOIN Letter L ON LR.LetterID = L.LetterID
WHERE DateRequested <= @ThroughDate AND (DateProcessed IS NULL OR DateProcessed = '1/1/1753 12:00:00')
AND LR.Deleted = 0 AND LR.AddEditMode = 0 AND LR.Suspend = 0 AND LR.Edited = 0 AND LR.LetterID = @LetterID
ORDER BY LR.AccountID

GO
