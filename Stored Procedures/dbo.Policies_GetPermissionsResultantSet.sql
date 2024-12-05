SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE     PROCEDURE [dbo].[Policies_GetPermissionsResultantSet] @UserID INTEGER, @CustomerCode VARCHAR(7)
AS
SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#RSOP') IS NOT NULL
	DROP TABLE #RSOP;

CREATE TABLE #RSOP (
	[ID] INTEGER NULL,
	[Scope] VARCHAR(25) NULL,
	[AppliedTo] SQL_VARIANT NULL,
	[Description] VARCHAR(100) NULL,
	[Configured] BIT NULL,
	[PolicyTemplate] TEXT NULL,
	[PolicySettings] TEXT NULL
);

DECLARE @Results TABLE (
	[PermissionID] INTEGER NOT NULL,
	[AppliedID] INTEGER NOT NULL,
	[Scope] VARCHAR(25) NOT NULL,
	[AppliedTo] SQL_VARIANT NULL,
	[Description] VARCHAR(100) NULL,
	[Configured] BIT NOT NULL,
	[PolicySettings] TEXT NULL
);

DECLARE @id INTEGER;
DECLARE @Configured BIT;
DECLARE @Error INTEGER;
DECLARE @Permissions TABLE (
	[ID] INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	[PermissionID] INTEGER NOT NULL
);
DECLARE @Index INTEGER;

INSERT INTO @Permissions ([PermissionID])
SELECT [ID]
FROM [dbo].[Permissions];

SET @Index = 1;

WHILE EXISTS (SELECT * FROM @Permissions WHERE [ID] = @Index) BEGIN
	SELECT @id = [PermissionID]
	FROM @Permissions
	WHERE [ID] = @Index;

	TRUNCATE TABLE #RSOP;

	INSERT INTO #RSOP ([ID], [Scope], [AppliedTo], [Description], [Configured], [PolicyTemplate], [PolicySettings])
	EXEC [dbo].[Policies_GetAppliedPermissions] @PermissionID = @id, @UserID = @UserID, @CustomerCode = @CustomerCode, @Configured = @Configured OUTPUT;

	SET @Error = @@ERROR;

	IF @Error != 0 RETURN @Error;

	INSERT INTO @Results ([PermissionID], [AppliedID], [Scope], [AppliedTo], [Description], [Configured], [PolicySettings])
	SELECT @id, [ID], [Scope], [AppliedTo], [Description], [Configured], [PolicySettings]
	FROM #RSOP
	WHERE [ID] IS NOT NULL;

	SET @Index = @Index + 1;
END;

INSERT INTO @Results ([PermissionID], [AppliedID], [Scope], [AppliedTo], [Description], [Configured], [PolicySettings])
SELECT [Permissions].[ID], 0, 'System', 'Default', 'Default', 0, NULL
FROM [dbo].[Permissions]
WHERE NOT EXISTS (SELECT *
	FROM @Results AS [Results]
	WHERE [Results].[PermissionID] = [Permissions].[ID]);

SELECT [Results].[AppliedID],
	[Results].[PermissionID],
	[Permissions].[ModuleName],
	[Permissions].[PermissionName],
	[Permissions].[UserPermission],
	[Permissions].[CustomerPermission],
	[Permissions].[DeskPermission],
	[Permissions].[PolicyTemplate],
	[Results].[Scope],
	[Results].[AppliedTo],
	[Results].[Description],
	[Results].[Configured],
	[Results].[PolicySettings]
FROM @Results AS [Results]
INNER JOIN [dbo].[Permissions]
ON [Results].[PermissionID] = [Permissions].[ID]
ORDER BY [ModuleName], [PermissionName];

RETURN 0;
GO
