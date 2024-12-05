SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LetterRequest_GetItemsPending*/
CREATE Procedure [dbo].[sp_LetterRequest_GetItemsPending]
	@AccountID int
AS
-- Name:		sp_LetterRequest_GetItemsPending
-- Function:		This procedure will retrieve pending letter requests using the accountid as an input parameter.
-- Creation:		unknown 
--			Used by Letter Console 
-- Change History:	11/12/2004 jc changed join to letter table to use letterid not lettercode

	SELECT LR.*, L.Description
	FROM LetterRequest LR
	JOIN Letter L ON LR.LetterID = L.LetterID
	WHERE LR.AccountID = @AccountID AND LR.DateProcessed = '1/1/1753 12:00:00' AND LR.Deleted = 0
GO
