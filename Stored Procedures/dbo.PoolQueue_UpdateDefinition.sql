SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[PoolQueue_UpdateDefinition] @ID INTEGER, @Name VARCHAR(255), @Description VARCHAR(1000), @Conditions IMAGE, @QueueAhead INTEGER, @Order IMAGE, @ChangedBy INTEGER
AS
SET NOCOUNT ON;

DECLARE @Now DATETIME;
DECLARE @OldVersion BINARY(8);
DECLARE @NewVersion BINARY(8);

SET @Now = GETDATE();

BEGIN TRANSACTION;

UPDATE [dbo].[PoolQueueDefinitions]
SET @OldVersion = [Version],
	[Name] = @Name,
	[Description] = @Description,
	[Conditions] = @Conditions,
	[QueueAhead] = @QueueAhead,
	[Order] = @Order,
	[ChangedBy] = @ChangedBy,
	[LastModified] = @Now
WHERE [ID] = @ID;

SELECT @NewVersion = [Version]
FROM [dbo].[PoolQueueDefinitions]
WHERE [ID] = @ID;

UPDATE [dbo].[PoolQueueDefinitions_History]
SET [EndDate] = @Now
WHERE [ID] = @ID
AND [Version] = @OldVersion;

INSERT INTO [dbo].[PoolQueueDefinitions_History] ([ID], [Name], [Description], [Conditions], [QueueAhead], [Version], [Order], [ChangedBy], [StartDate], [EndDate])
VALUES (@ID, @Name, @Description, @Conditions, @QueueAhead, @NewVersion, @Order, @ChangedBy, @Now, NULL);

COMMIT TRANSACTION;

RETURN 0;


GO
