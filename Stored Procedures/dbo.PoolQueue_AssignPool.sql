SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[PoolQueue_AssignPool] @DefinitionID INTEGER, @UserID INTEGER, @ChangedBy INTEGER
AS
SET NOCOUNT ON;

IF @DefinitionID IS NOT NULL AND NOT EXISTS (SELECT * FROM [dbo].[PoolQueueDefinitions] WHERE [ID] = @DefinitionID) BEGIN
	RAISERROR('Pool queue #%d does not exist.', 16, 1, @DefinitionID);
	RETURN 1;
END;

DECLARE @Now DATETIME;
DECLARE @Version BINARY(8);
DECLARE @OldAssignment INTEGER;

SET @Now = GETDATE();

BEGIN TRANSACTION;

-- If assigning user to a pool, get the current pool version
IF @DefinitionID IS NOT NULL
	SELECT @Version = [Version]
	FROM [dbo].[PoolQueueDefinitions]
	WHERE [ID] = @DefinitionID;

-- Determine the current user assignment, if any
SELECT @OldAssignment = [DefinitionID]
FROM [dbo].[PoolQueueAssignments]
WHERE [UserID] = @UserID
OR (@UserID IS NULL
	AND [UserID] IS NULL);

IF @OldAssignment IS NOT NULL BEGIN
	-- Record the ending date of the previous user assignment
	UPDATE [dbo].[PoolQueueAssignments_History]
	SET [EndDate] = @Now
	WHERE ([UserID] = @UserID
		OR ([UserID] IS NULL
			AND @UserID IS NULL))
	AND [EndDate] IS NULL;

	IF @DefinitionID IS NOT NULL
		-- If assigning user to pool, update user assignment to specified pool ID
		UPDATE [dbo].[PoolQueueAssignments]
		SET [DefinitionID] = @DefinitionID
		WHERE [UserID] = @UserID
		OR (@UserID IS NULL
			AND [UserID] IS NULL);
	ELSE
		-- If not assigning user to pool, delete user assignment
		DELETE FROM [dbo].[PoolQueueAssignments]
		WHERE [UserID] = @UserID
		OR (@UserID IS NULL
			AND [UserID] IS NULL);
END;
ELSE BEGIN
	IF @DefinitionID IS NOT NULL
		-- If assigning user to pool, insert new assignment
		INSERT INTO [dbo].[PoolQueueAssignments] ([UserID], [DefinitionID])
		VALUES (@UserID, @DefinitionID);
END;

IF @DefinitionID IS NOT NULL
	-- If assigning user to pool, record new assignment to history
	INSERT INTO [dbo].[PoolQueueAssignments_History] ([UserID], [DefinitionID], [Version], [ChangedBy], [StartDate], [EndDate])
	VALUES (@UserID, @DefinitionID, @Version, @ChangedBy, @Now, NULL);

COMMIT TRANSACTION;

RETURN 0;





GO
