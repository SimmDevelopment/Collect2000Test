SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_LetterRequest_GetByID*/
CREATE Procedure [dbo].[sp_LetterRequest_GetByID]
@LetterRequestID INT
AS
-- Name:		sp_LetterRequest_GetByID
-- Function:		This procedure will retrieve letter requests using the letterrequestid as an input parameter.
-- Creation:		unknown 
--			Used by Letter Console 
-- Change History:	11/12/2004 jc changed join to letter table to use letterid not lettercode

	SELECT LR.*, L.Description
	FROM LetterRequest LR
	JOIN Letter L ON LR.LetterID = L.LetterID
	WHERE LR.LetterRequestID = @LetterRequestID
GO
