SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustomCustGroupLetter_DeleteByGroupAndLetter*/
CREATE Procedure [dbo].[sp_CustomCustGroupLetter_DeleteByGroupAndLetter]
	@CustomCustGroupID int,
	@LetterCode varchar(5)
AS

--Start a transaction
BEGIN TRAN T1

--Delete this letter from all Customers in the group
DELETE CustLtrAllow
FROM Fact F
JOIN CustLtrAllow CLA ON F.CustomerID = CLA.CustCode AND F.CustomGroupID = @CustomCustGroupID
WHERE CLA.LtrCode = @LetterCode

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN T1
	RETURN
END

--Delete this letter from the group itself
DELETE FROM CustomCustGroupLetter
WHERE CustomCustGroupID = @CustomCustGroupID AND LetterCode = @LetterCode

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN T1
	RETURN
END

COMMIT TRAN T1

GO
