SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_CustomCustGroup_Delete*/
CREATE Procedure [dbo].[sp_CustomCustGroup_Delete]
@ID INT
AS

BEGIN TRAN T1

--Is this group a LetterGroup
IF EXISTS (SELECT * FROM CustomCustGroups WHERE ID = @ID AND LetterGroup = 1)
BEGIN
	--Remove all of the CustomCustGroupLetters for this group
	DELETE FROM CustomCustGroupLetter
	WHERE CustomCustGroupID = @ID
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN T1
		RETURN
	END
END

--Delete the actual group
DELETE FROM CustomCustGroups
WHERE ID = @ID

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN T1
	RETURN
END

--Commit the transaction
COMMIT TRAN T1

GO
