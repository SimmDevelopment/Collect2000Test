SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_AddNotesForPrintJob*/
CREATE procedure [dbo].[sp_AddNotesForPrintJob]
	@JobName varchar(256),
	@LoginName varchar(10),
	@Comment text,
	@LetterRequestIDs dbo.IntList_TableType READONLY
AS       
-- Name:	sp_AddNotesForPrintJob
-- Function:	This procedure will insert notes for each letter
--		printed from letter console.
-- Creation:	03/05/2004 jc
--		Used by Letter Console to add notes when printing letters.
-- Change History:	
BEGIN

	IF NOT EXISTS(SELECT * FROM @LetterRequestIDs)
	BEGIN
		INSERT INTO notes (number,ctl,created,user0,action,result,comment) 
		SELECT lr.accountid,'ctl',GETDATE(),@LoginName,'+++++','+++++',@Comment
		FROM letterrequest lr 
		WHERE lr.jobname = @JobName
	END
	ELSE
	BEGIN
		INSERT INTO notes (number,ctl,created,user0,action,result,comment) 
		SELECT lr.accountid,'ctl',GETDATE(),@LoginName,'+++++','+++++',@Comment
		FROM letterrequest lr INNER JOIN @LetterRequestIDs ids
			ON lr.LetterRequestID = ids.id
	END
END

GO
