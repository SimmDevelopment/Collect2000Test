SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[User_CopyRole] @SourceRoleID INTEGER, @DestRoleID INTEGER, @UserID INTEGER
AS
SET NOCOUNT ON;

IF NOT EXISTS (SELECT * FROM [dbo].[Users] WHERE [ID] = @UserID)
	SET @UserID = NULL;

BEGIN TRANSACTION;

DELETE FROM [dbo].[AppliedPermissions]
WHERE [RoleID] = @DestRoleID;

INSERT INTO [dbo].[AppliedPermissions] ([RoleID], [PermissionID], [Configured], [PolicySettings], [ModifiedBy], [ModifiedDate])
SELECT @DestRoleID AS [RoleID], [PermissionID], [Configured], [PolicySettings], @UserID AS [ModifiedBy], GETDATE() AS [ModifiedDate]
FROM [dbo].[AppliedPermissions]
WHERE [RoleID] = @SourceRoleID;

DELETE FROM [dbo].[LetterRoles]
WHERE [RoleID] = @DestRoleID;

INSERT INTO [dbo].[LetterRoles] ([LetterID], [RoleID], [DateCreated], [DateUpdated])
SELECT [LetterID], @DestRoleID AS [RoleID], GETDATE() AS [DateCreated], GETDATE() AS [DateUpdated]
FROM [dbo].[LetterRoles]
WHERE [RoleID] = @SourceRoleID;

COMMIT TRANSACTION;

RETURN 0;


GO
