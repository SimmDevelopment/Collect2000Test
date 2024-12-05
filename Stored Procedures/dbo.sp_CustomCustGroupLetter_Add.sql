SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*sp_CustomCustGroupLetter_Add*/
CREATE Procedure [dbo].[sp_CustomCustGroupLetter_Add]
@CustomCustGroupLetterID int OUTPUT,
@CustomCustGroupID int,
@LetterID int,
@LetterCode varchar(5),
@CopyCustomer bit,
@SaveImage bit
AS

--Start a transaction
BEGIN TRAN T1

--Update existing letters in the group
UPDATE CustLtrAllow
SET CopyCustomer = @CopyCustomer,
	SaveImage = @SaveImage
FROM CustLtrAllow
INNER JOIN Fact
ON CustLtrAllow.CustCode = Fact.CustomerID
WHERE Fact.CustomGroupID = @CustomCustGroupID;

--Add this letter to all of the customers in the group
INSERT INTO CustLtrAllow
(CustCode, LtrCode, CopyCustomer, SaveImage)
SELECT CustomerID, @LetterCode, @CopyCustomer, @SaveImage
FROM FACT
WHERE CustomGroupID = @CustomCustGroupID
AND NOT EXISTS (
	SELECT *
	FROM CustLtrAllow
	WHERE Fact.CustomerID = CustLtrAllow.CustCode
	AND CustLtrAllow.LtrCode = @LetterCode
);

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN T1
	RETURN
END

--Now add the letter to the group itself
INSERT INTO CustomCustGroupLetter
(
CustomCustGroupID,
LetterID,
LetterCode,
CopyCustomer,
SaveImage
)
VALUES
(
@CustomCustGroupID,
@LetterID,
@LetterCode,
@CopyCustomer,
@SaveImage
)

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN T1
	RETURN
END

SET @CustomCustGroupLetterID = SCOPE_IDENTITY()

COMMIT TRAN T1

GO
