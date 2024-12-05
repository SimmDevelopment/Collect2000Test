SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRequest_DeleteByCustomCustGroup*/
CREATE Procedure [dbo].[sp_LetterRequest_DeleteByCustomCustGroup]
	@CustomCustGroupID int,
	@LetterID int
AS

UPDATE LetterRequest
SET DELETED = 1
FROM FACT F
JOIN LetterRequest LR ON F.CustomerID = LR.CustomerCode
WHERE F.CustomGroupID = @CustomCustGroupID AND LR.LetterID = @LetterID AND LR.DateProcessed = '1/1/1753 12:00:00' AND LR.Deleted = 0

GO
