SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[PoolQueue_InsertDefinition] @Name VARCHAR(255), @Description VARCHAR(1000), @Conditions IMAGE, @QueueAhead INTEGER, @Order IMAGE, @ChangedBy INTEGER, @ID INTEGER OUTPUT
AS
SET NOCOUNT ON;

DECLARE @Now DATETIME;
DECLARE @Version BINARY(8);

SET @Now = GETDATE();

BEGIN TRANSACTION;

INSERT INTO [dbo].[PoolQueueDefinitions] ([Name], [Description], [Conditions], [QueueAhead], [Order], [ChangedBy], [LastModified])
VALUES (@Name, @Description, @Conditions, @QueueAhead, @Order, @ChangedBy, @Now);

SELECT @ID = [ID],
	@Version = [Version]
FROM [dbo].[PoolQueueDefinitions]
WHERE [ID] = SCOPE_IDENTITY();

INSERT INTO [dbo].[PoolQueueDefinitions_History] ([ID], [Name], [Description], [Conditions], [QueueAhead], [Version], [Order], [ChangedBy], [StartDate], [EndDate])
VALUES (@ID, @Name, @Description, @Conditions, @QueueAhead, @Version, @Order, @ChangedBy, @Now, NULL);

COMMIT TRANSACTION;

RETURN 0;


GO
