SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[QueueEngine_SupportQueue_Complete] @ID INTEGER, @AccountID INTEGER, @UserName VARCHAR(10), @Action VARCHAR(5), @Queue VARCHAR(3)
AS
SET NOCOUNT ON;

BEGIN TRANSACTION;

DELETE FROM [dbo].[SupportQueueItems] WHERE [ID] = @ID;

INSERT INTO [dbo].[notes] ([number], [user0], [created], [action], [result], [comment])
VALUES (@AccountID, @UserName, GETDATE(), @Action, @Queue, 'Completed');

COMMIT TRANSACTION;

RETURN 0;

GO
