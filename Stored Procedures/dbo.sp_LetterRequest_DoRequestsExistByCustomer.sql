SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRequest_DoRequestsExistByCustomer*/
CREATE Procedure [dbo].[sp_LetterRequest_DoRequestsExistByCustomer]
	@CustomerCode varchar(7),
	@LetterID int
AS

IF EXISTS
(
	SELECT LetterRequestID
	FROM LetterRequest
	WHERE CustomerCode = @CustomerCode AND LetterID = @LetterID AND DateProcessed = '1/1/1753 12:00:00' AND Deleted = 0
)
BEGIN
	RETURN 1
END
ELSE
BEGIN
	RETURN 0
END

GO
