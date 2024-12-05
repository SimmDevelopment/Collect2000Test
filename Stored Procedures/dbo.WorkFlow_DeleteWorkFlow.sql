SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_DeleteWorkFlow] @ID UNIQUEIDENTIFIER, @UserID INTEGER
AS
SET NOCOUNT ON;

DECLARE @Version INTEGER;

INSERT INTO [dbo].[WorkFlow_VersionHistory] ([ID], [Version], [StartingActivity], [LayoutXML], [ModifiedBy], [ModifiedDate])
SELECT [ID], [Version], [StartingActivity], [LayoutXML], [ModifiedBy], [ModifiedDate]
FROM [dbo].[WorkFlows] WITH (UPDLOCK)
WHERE [ID] = @ID;

UPDATE [dbo].[WorkFlows]
SET [Active] = 0,
	[ModifiedBy] = @UserID,
	[ModifiedDate] = GETDATE(),
	[Version] = [Version] + 1,
	@Version = [Version]
WHERE [ID] = @ID;

INSERT INTO [dbo].[WorkFlow_ActivityVersionHistory] ([ID], [WorkFlowID], [Version], [TypeName], [ActivityXML], [Active])
SELECT [ID], [WorkFlowID], [Version], [TypeName], [ActivityXML], [Active]
FROM [dbo].[WorkFlow_Activities] WITH (UPDLOCK)
WHERE [WorkFlowID] = @ID
AND [Active] = 1;

UPDATE [dbo].[WorkFlow_Activities]
SET [Active] = 0,
	[Version] = @Version
WHERE [WorkFlowID] = @ID;

RETURN 0;
GO
