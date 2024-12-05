SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_PurgeWorkFlows] @IAmSure BIT = 0
AS
SET NOCOUNT ON;

IF @IAmSure IS NULL OR @IAmSure = 0 BEGIN
	RAISERROR('Are you sure?', 16, 1);
	RETURN 1;
END;

DELETE
FROM [dbo].[WorkFlow_ActivityVersionHistory];

DELETE
FROM [dbo].[WorkFlow_VersionHistory];

UPDATE [dbo].[WorkFlows]
SET [StartingActivity] = NULL;

DELETE
FROM [dbo].[WorkFlow_Activities];

DELETE
FROM [dbo].[WorkFlows];

RETURN 0;
GO
