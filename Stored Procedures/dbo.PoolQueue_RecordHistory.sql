SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[PoolQueue_RecordHistory] @UID UNIQUEIDENTIFIER OUTPUT, @DefinitionID INTEGER, @Version BINARY(8), @UserID INTEGER, @AccountID INTEGER
AS
SET NOCOUNT ON;

BEGIN TRANSACTION;

IF @UID IS NULL OR @UID = '00000000-0000-0000-0000-000000000000' OR NOT EXISTS (SELECT * FROM [dbo].[PoolQueueAssignments_WorkHistory] WHERE [UID] = @UID AND [DefinitionID] = @DefinitionID AND [Version] = @Version AND [UserID] = @UserID) BEGIN
	SET @UID = NEWID();

	INSERT INTO [dbo].[PoolQueueAssignments_WorkHistory] ([UID], [DefinitionID], [Version], [UserID], [StartDate], [EndDate], [Accounts], [Worked], [Contacted])
	VALUES (@UID, @DefinitionID, @Version, @UserID, GETDATE(), GETDATE(), 1, 0, 0);
END;
ELSE BEGIN
	UPDATE [dbo].[PoolQueueAssignments_WorkHistory]
	SET [EndDate] = GETDATE(),
		[Accounts] = [Accounts] + 1
	WHERE [UID] = @UID;
END;

INSERT INTO [dbo].[PoolQueueAssignments_WorkHistoryAccounts] ([HistoryID], [AccountID], [StartDate], [Worked], [Contacted])
VALUES (@UID, @AccountID, GETDATE(), 0, 0);

COMMIT TRANSACTION;


GO
