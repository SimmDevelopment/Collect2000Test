SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_RenamePolicy] @OldModuleName VARCHAR(260), @OldPermissionName VARCHAR(50), @NewModuleName VARCHAR(260), @NewPermissionName VARCHAR(50)
AS
SET NOCOUNT ON;

DECLARE @OldID INTEGER;
DECLARE @NewID INTEGER;

SET @OldID = NULL;
SET @NewID = NULL;

BEGIN TRANSACTION;

SELECT @OldID = [ID]
FROM [dbo].[Permissions] WITH (ROWLOCK, XLOCK)
WHERE [ModuleName] = @OldModuleName
AND [PermissionName] = @OldPermissionName;

SELECT @NewID = [ID]
FROM [dbo].[Permissions] WITH (ROWLOCK, XLOCK)
WHERE [ModuleName] = @NewModuleName
AND [PermissionName] = @NewPermissionName;

IF @OldID IS NOT NULL BEGIN
	IF @NewID IS NOT NULL BEGIN
		-- The new permission does exist, probably due to DBUpdate
		-- Copy applied permissions to new permission and delete old permission
		UPDATE [dbo].[AppliedPermissions]
		SET [PermissionID] = @NewID
		WHERE [PermissionID] = @OldID;

		UPDATE [dbo].[AppliedPermissionsAudit]
		SET [PermissionID] = @NewID
		WHERE [PermissionID] = @OldID;

		DELETE FROM [dbo].[Permissions]
		WHERE [ID] = @OldID;
	END;
	ELSE BEGIN
		-- The new permission does not yet exist, rename the existing permission instead
		UPDATE [dbo].[Permissions]
		SET [ModuleName] = @NewModuleName,
			[PermissionName] = @NewPermissionName
		WHERE [ID] = @OldID;
	END;
END;

COMMIT TRANSACTION;
RETURN 0;




GO
