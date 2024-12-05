SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[PoolQueue_DeleteDefinition] @ID INTEGER
AS
SET NOCOUNT ON;

DECLARE @Version BINARY(8);

BEGIN TRANSACTION;

SELECT @Version = [Version]
FROM [dbo].[PoolQueueDefinitions]
WHERE [ID] = @ID;

DELETE FROM [dbo].[PoolQueueDefinitions]
WHERE [ID] = @ID;

UPDATE [dbo].[PoolQueueDefinitions_History]
SET [EndDate] = GETDATE()
WHERE [ID] = @ID
AND [Version] = @Version;

COMMIT TRANSACTION;

RETURN 0;


GO
