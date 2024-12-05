SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[PermissionAliasView]
AS
WITH [AliasedPermissions] AS (
	SELECT
		[ID],
		[ModuleName] AS [Module],
		[PermissionName] AS [Permission],
		[ModuleName] AS [ModuleAlias],
		[PermissionName] AS [PermissionAlias],
		CAST(0 AS INTEGER) AS [Depth]
	FROM [dbo].[Permissions]
	UNION ALL
	SELECT
		[AliasedPermissions].[ID],
		[AliasedPermissions].[Module],
		[AliasedPermissions].[Permission],
		[PermissionAliases].[NewModuleName],
		[PermissionAliases].[NewPermissionName],
		CAST([AliasedPermissions].[Depth] + 1 AS INTEGER) AS [Depth]
	FROM [dbo].[PermissionAliases]
	INNER JOIN [AliasedPermissions]
	ON [AliasedPermissions].[ModuleAlias] = [PermissionAliases].[ModuleName]
	AND [AliasedPermissions].[PermissionAlias] = [PermissionAliases].[PermissionName]
)
SELECT
	[ID],
	[Module],
	[Permission],
	[ModuleAlias],
	[PermissionAlias],
	CASE [Depth]
		WHEN 0 THEN CAST(0 AS BIT)
		ELSE CAST(1 AS BIT)
	END AS [Aliased],
	[Depth]
FROM [AliasedPermissions]
--OPTION (MAXRECURSION 25);

GO
