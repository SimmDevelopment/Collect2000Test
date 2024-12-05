SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustomCustGroupLetter_Update*/
CREATE Procedure [dbo].[sp_CustomCustGroupLetter_Update]
@CustomCustGroupLetterID int,
@CustomCustGroupID int,
@LetterID int,
@LetterCode varchar(5),
@CopyCustomer bit,
@SaveImage bit
AS

--Start a transaction
BEGIN TRAN T1

--UPDATE all of the customer letters that in this group
UPDATE CustLtrAllow
SET
	CopyCustomer = @CopyCustomer,
	SaveImage = @SaveImage
FROM Fact F
JOIN CustLtrAllow CLA ON F.CustomerID = CLA.CustCode AND F.CustomGroupID = @CustomCustGroupID
WHERE CLA.LtrCode = @LetterCode

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN T1
	RETURN
END

--Update the actual GroupLetter
UPDATE CustomCustGroupLetter
SET
CustomCustGroupID = @CustomCustGroupID,
LetterID = @LetterID,
LetterCode = @LetterCode,
CopyCustomer = @CopyCustomer,
SaveImage = @SaveImage
WHERE CustomCustGroupLetterID = @CustomCustGroupLetterID

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN T1
	RETURN
END

COMMIT TRAN T1

GO
