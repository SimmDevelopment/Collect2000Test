SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_SaveWorkFlowStartingActivity] @ID UNIQUEIDENTIFIER, @StartingActivity UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

UPDATE [dbo].[WorkFlows]
SET [StartingActivity] = @StartingActivity
WHERE [ID] = @ID;

RETURN 0;
GO
