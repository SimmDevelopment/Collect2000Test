SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_LetterRequest_SetJobName*/
CREATE Procedure [dbo].[sp_LetterRequest_SetJobName]
	@LetterRequestIDs dbo.IntList_TableType READONLY,
	@JobName varchar(256),
	@LetterID int,
	@ThroughDate datetime
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM @LetterRequestIDs)
	BEGIN
		UPDATE LetterRequest
		SET JobName = @JobName
		WHERE DateRequested <= @ThroughDate AND (DateProcessed IS NULL OR DateProcessed = '1/1/1753 12:00:00')
		AND Deleted = 0 AND AddEditMode = 0 AND Suspend = 0 AND Edited = 0 AND LetterID = @LetterID
	END
	ELSE
	BEGIN
		UPDATE [dbo].[LetterRequest] 
		SET JobName = @JobName
		FROM dbo.LetterRequest lr INNER JOIN @LetterRequestIDs ids
			ON lr.LetterRequestID = ids.Id
	END
END

GO
