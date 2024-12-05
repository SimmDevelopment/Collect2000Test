SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRequest_DoRequestsExistByCustomerGroup*/
CREATE Procedure [dbo].[sp_LetterRequest_DoRequestsExistByCustomerGroup]
	@CustomCustGroupID int,
	@LetterID int
AS

IF EXISTS
(
	SELECT LR.LetterRequestID
	FROM FACT F
	JOIN LetterRequest LR ON F.CustomerID = LR.CustomerCode
	WHERE F.CustomGroupID = @CustomCustGroupID AND LR.LetterID = @LetterID AND LR.DateProcessed = '1/1/1753 12:00:00' AND LR.Deleted = 0
)
BEGIN
	RETURN 1
END
ELSE
BEGIN
	RETURN 0
END
	
GO
