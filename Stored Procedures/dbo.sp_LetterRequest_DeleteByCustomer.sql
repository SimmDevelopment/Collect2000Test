SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRequest_DeleteByCustomer*/
CREATE Procedure [dbo].[sp_LetterRequest_DeleteByCustomer]
	@CustomerCode varchar(7),
	@LetterID int
AS

UPDATE LetterRequest
SET Deleted = 1
WHERE CustomerCode = @CustomerCode AND LetterID = @LetterID AND DateProcessed = '1/1/1753 12:00:00' AND Deleted = 0

GO
