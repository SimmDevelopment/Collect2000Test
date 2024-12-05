SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[spUpdateSpecialCommentOnAccounts]
@AccountIDs dbo.IntList_TableType READONLY,
@ListCode VARCHAR(5)
AS
BEGIN
	UPDATE cbr_accounts SET specialComment = @ListCode, specialCommentOverride = CASE @ListCode WHEN '' THEN NULL ELSE 1 END WHERE accountID IN (SELECT Id FROM @AccountIDs)
END

GO
