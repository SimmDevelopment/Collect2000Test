SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_RedirectActivity] @ActivityID UNIQUEIDENTIFIER, @RedirectActivityID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

IF @RedirectActivityID IS NOT NULL AND NOT EXISTS (SELECT * FROM [dbo].[WorkFlow_Activities] WHERE [ID] = @RedirectActivityID)
	SET @RedirectActivityID = NULL;

IF @RedirectActivityID IS NULL
	DELETE FROM [dbo].[WorkFlow_Execution]
	WHERE [ActivityID] = @ActivityID;
ELSE
	UPDATE [dbo].[WorkFlow_Execution]
	SET [ActivityID] = @RedirectActivityID
	WHERE [ActivityID] = @ActivityID;

RETURN 0;
GO
