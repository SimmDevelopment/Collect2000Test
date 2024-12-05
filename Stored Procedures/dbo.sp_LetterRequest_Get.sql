SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_LetterRequest_Get*/
CREATE Procedure [dbo].[sp_LetterRequest_Get]
(           
            @KeyID int
)
AS
-- Name:                      sp_LetterRequest_Get
-- Function:                  This procedure will retrieve letter requests using the accountid as an input parameter.
-- Creation:                  6/18/2003 
--                                 Used by Letter Console 
-- Change History:
--                                 9/26/2003 jc Changed where clause from 'WHERE LR.AccountID = @KeyID AND LR.Deleted = 0'
--                                 to 'WHERE LR.AccountID = @KeyID' to allow deleted letter requests to show in letter history.
--                                 Deleted letter requests are not removed from the table, the bit field 'deleted' is set to 1.
--                                 11/12/2004 jc changed join to letter table to use letterid not lettercode
--                                  8/23/2006 kmo change to order by daterequested.
--
 
            SELECT LR.*, L.Description
            FROM LetterRequest LR
            JOIN Letter L ON LR.LetterID = L.LetterID
            WHERE LR.AccountID = @KeyID
            order by lr.daterequested

GO
