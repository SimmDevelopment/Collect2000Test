SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*dbo.sp_LetterRequest_GetByJob*/
CREATE Procedure [dbo].[sp_LetterRequest_GetByJob]
	@JobName varchar(256),
	@StartingAccountID int
AS
-- Name:		sp_LetterRequest_GetByJob
-- Function:		This procedure will retrieve letter requests using the job name as an input parameter.
-- Creation:		unknown 
--			Used by Letter Console 
-- Change History:	11/12/2004 jc changed join to letter table to use letterid not lettercode

	IF @StartingAccountID = 0
	BEGIN
		SELECT LR.*, L.Description
		FROM LetterRequest LR
		JOIN Letter L ON LR.LetterID = L.LetterID
		WHERE JobName = @JobName
		ORDER BY AccountID
	END
	ELSE
	BEGIN
		SELECT LR.*, L.Description
		FROM LetterRequest LR
		JOIN Letter L ON LR.LetterID = L.LetterID
		WHERE JobName = @JobName AND AccountID >= @StartingAccountID
		ORDER BY AccountID
	END
GO
