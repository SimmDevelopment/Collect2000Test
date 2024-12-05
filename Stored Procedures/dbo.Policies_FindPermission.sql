SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_FindPermission] @ModuleName VARCHAR(260), @PermissionName VARCHAR(50), @PermissionID INTEGER OUTPUT
AS
SET NOCOUNT ON;

DECLARE @Attempts INTEGER;
SET @Attempts = 0;

WHILE @Attempts < 10 BEGIN
	SELECT @PermissionID = [ID]
	FROM [dbo].[Permissions]
	WHERE [ModuleName] = @ModuleName
	AND [PermissionName] = @PermissionName;

	IF @PermissionID IS NOT NULL BEGIN
		RETURN 1;
	END;

	SELECT @ModuleName = [NewModuleName],
		@PermissionName = [NewPermissionName]
	FROM [dbo].[PermissionAliases]
	WHERE [ModuleName] = @ModuleName
	AND [PermissionName] = @PermissionName;

	IF @@ROWCOUNT = 0 BEGIN
		RETURN 1;
	END;

	SET @Attempts = @Attempts + 1;
END;

RETURN 1;


GO
