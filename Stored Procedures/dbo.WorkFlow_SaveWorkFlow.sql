SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_SaveWorkFlow] @ID UNIQUEIDENTIFIER, @Name NVARCHAR(260), @LayoutXML NTEXT, @UserID INTEGER
AS
SET NOCOUNT ON;

INSERT INTO [dbo].[WorkFlow_VersionHistory] ([ID], [Version], [Name], [StartingActivity], [LayoutXML], [ModifiedBy], [ModifiedDate])
SELECT [ID], [Version], [Name], [StartingActivity], [LayoutXML], [ModifiedBy], [ModifiedDate]
FROM [dbo].[WorkFlows] WITH (UPDLOCK)
WHERE [ID] = @ID;

IF @@ROWCOUNT > 0 BEGIN
	UPDATE [dbo].[WorkFlows]
	SET [Name] = @Name,
		[LayoutXML] = @LayoutXML,
		[ModifiedBy] = @UserID,
		[ModifiedDate] = GETDATE(),
		[Version] = [Version] + 1
	WHERE [ID] = @ID;
END;
ELSE BEGIN
	INSERT INTO [dbo].[WorkFlows] ([ID], [Name], [LayoutXML], [Active], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [Version])
	VALUES (@ID, @Name, @LayoutXML, 1, @UserID, GETDATE(), @UserID, GETDATE(), 1);
END;

SELECT [WorkFlows].[Version],
	[WorkFlows].[ModifiedBy],
	CASE
		WHEN [Users].[ID] IS NOT NULL
		THEN [Users].[LoginName]
		WHEN [Users].[ID] IS NULL AND [WorkFlows].[ModifiedBy] = 0
		THEN 'ADMIN'
		ELSE 'UNKNOWN'
	END AS [ModifiedLoginName],
	CASE
		WHEN [Users].[ID] IS NOT NULL
		THEN [Users].[UserName]
		WHEN [Users].[ID] IS NULL AND [WorkFlows].[ModifiedBy] = 0
		THEN 'Administrator'
		ELSE 'Unknown User'
	END AS [ModifiedUserName],
	[WorkFlows].[ModifiedDate]
FROM [dbo].[WorkFlows]
LEFT OUTER JOIN [dbo].[Users]
ON [WorkFlows].[ModifiedBy] = [Users].[ID]
WHERE [WorkFlows].[ID] = @ID;

RETURN 0;
GO
