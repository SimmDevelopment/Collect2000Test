SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_UpdateActivity] @ID UNIQUEIDENTIFIER, @Title VARCHAR(50), @TypeName VARCHAR(260), @ActivityXML NTEXT
AS
SET NOCOUNT ON;

INSERT INTO [dbo].[WorkFlow_ActivityVersionHistory] ([ID], [WorkFlowID], [Version], [Title], [TypeName], [ActivityXML], [Active])
SELECT [ID], [WorkFlowID], [Version], [Title], [TypeName], [ActivityXML], [Active]
FROM [dbo].[WorkFlow_Activities] WITH (UPDLOCK)
WHERE [ID] = @ID;

UPDATE [dbo].[WorkFlow_Activities]
SET [Title] = @Title,
	[ActivityXML] = @ActivityXML,
	[Version] = [WorkFlows].[Version]
FROM [dbo].[WorkFlow_Activities]
INNER JOIN [dbo].[WorkFlows]
ON [WorkFlow_Activities].[WorkFlowID] = [WorkFlows].[ID]
WHERE [WorkFlow_Activities].[ID] = @ID;

RETURN 0;
GO
