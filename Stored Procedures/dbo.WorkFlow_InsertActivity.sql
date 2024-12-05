SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_InsertActivity] @ID UNIQUEIDENTIFIER, @WorkFlowID UNIQUEIDENTIFIER, @Title VARCHAR(50), @TypeName VARCHAR(260), @ActivityXML NTEXT
AS
SET NOCOUNT ON;

INSERT INTO [dbo].[WorkFlow_Activities] ([ID], [WorkFlowID], [Title], [TypeName], [ActivityXML], [Active], [Version])
SELECT @ID, [WorkFlows].[ID], @Title, @TypeName, @ActivityXML, 1, [WorkFlows].[Version]
FROM [dbo].[WorkFlows]
WHERE [WorkFlows].[ID] = @WorkFlowID;

RETURN 0;
GO
