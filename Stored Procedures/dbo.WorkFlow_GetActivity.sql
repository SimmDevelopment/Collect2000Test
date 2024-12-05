SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_GetActivity] @ActivityID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

SELECT [WorkFlowID], [TypeName], [ActivityXML], [LastEvaluated]
FROM [dbo].[WorkFlow_Activities]
WHERE [ID] = @ActivityID;

RETURN 0;
GO
