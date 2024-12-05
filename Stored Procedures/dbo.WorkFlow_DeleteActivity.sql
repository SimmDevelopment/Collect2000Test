SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_DeleteActivity] @ID UNIQUEIDENTIFIER, @RedirectActivityID UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'
AS
SET NOCOUNT ON;

INSERT INTO [dbo].[WorkFlow_ActivityVersionHistory] ([ID], [WorkFlowID], [Version], [Title], [TypeName], [ActivityXML], [Active])
SELECT [ID], [WorkFlowID], [Version], [Title], [TypeName], [ActivityXML], [Active]
FROM [dbo].[WorkFlow_Activities] WITH (UPDLOCK)
WHERE [ID] = @ID;

UPDATE [dbo].[WorkFlow_Activities]
SET [Active] = 0,
	[RedirectActivityID] = @RedirectActivityID
FROM [dbo].[WorkFlow_Activities]
INNER JOIN [dbo].[WorkFlows]
ON [WorkFlow_Activities].[WorkFlowID] = [WorkFlows].[ID]
WHERE [WorkFlow_Activities].[ID] = @ID;

RETURN 0;
GO
