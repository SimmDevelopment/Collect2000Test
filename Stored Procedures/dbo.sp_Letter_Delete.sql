SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Letter_Delete*/
CREATE Procedure [dbo].[sp_Letter_Delete]
@LetterID int
AS

--Delete any roles on this letter
DELETE FROM LetterRoles
WHERE LetterID = @LetterID

--Delete any occurences of this letter on a group
DELETE FROM CustomCustGroupLetter
WHERE LetterID = @LetterID

--Delete any occurences of this letter in CustLtrAllow
DELETE CustLtrAllow
FROM Letter L
JOIN CustLtrAllow CLA ON L.Code = CLA.LtrCode
WHERE L.LetterID = @LetterID

--Delete the actual letter
DELETE FROM Letter
WHERE  LetterID = @LetterID

GO
