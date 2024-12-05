SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_GetAppliedPermissions] @PermissionID INTEGER, @UserID INTEGER, @CustomerCode VARCHAR(7), @Configured BIT OUTPUT
AS
SET NOCOUNT ON;

IF @PermissionID IS NULL BEGIN
	SET @Configured = 0;

	SELECT CAST(NULL AS INTEGER) AS [ID], 'System' AS [Scope], CAST('Default' AS SQL_VARIANT) AS [AppliedTo], CAST(0 AS BIT) AS [Configured], CAST(NULL AS TEXT) AS [PolicyTemplate], CAST(NULL AS TEXT) AS [PolicySettings];

	RETURN 0;
END;

DECLARE @Effective TABLE (
	[EffectiveID] INTEGER NOT NULL IDENTITY(1, 1),
	[ID] INTEGER NULL,
	[Scope] VARCHAR(25) NOT NULL,
	[AppliedTo] SQL_VARIANT NULL,
	[Description] VARCHAR(100) NULL,
	[Configured] BIT NOT NULL
);

IF @UserID IS NOT NULL BEGIN
	INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
	SELECT [AppliedPermissions].[ID], 'User', [Users].[ID], [Users].[LoginName], [Configured]
	FROM [dbo].[AppliedPermissions]
	INNER JOIN [dbo].[Users]
	ON [Users].[ID] = [AppliedPermissions].[UserID]
	WHERE [AppliedPermissions].[PermissionID] = @PermissionID
	AND [Users].[ID] = @UserID
	AND [Users].[Active] = 1;

	IF @@ROWCOUNT = 0 BEGIN
		DECLARE @RoleID INTEGER;
		DECLARE @DeskCode VARCHAR(10);
		DECLARE @TeamID INTEGER;
		DECLARE @DepartmentID INTEGER;
		DECLARE @DeskBranch VARCHAR(5);
		DECLARE @UserBranch VARCHAR(5);
		
		SELECT TOP 1
			@RoleID = [Users].[RoleID],
			@DeskCode = [desk].[code],
			@TeamID = [Teams].[ID],
			@DepartmentID = [Departments].[ID],
			@DeskBranch = [DeskBranches].[Code],
			@UserBranch = [UserBranches].[Code]
		FROM [dbo].[Users]
		LEFT OUTER JOIN [dbo].[desk]
		ON [desk].[code] = [Users].[DeskCode]
		LEFT OUTER JOIN [dbo].[Teams]
		ON [desk].[TeamID] = [Teams].[ID]
		LEFT OUTER JOIN [dbo].[Departments]
		ON [Teams].[DepartmentID] = [Departments].[ID]
		LEFT OUTER JOIN [dbo].[BranchCodes] AS [DeskBranches]
		ON [Departments].[Branch] = [DeskBranches].[Code]
		LEFT OUTER JOIN [dbo].[BranchCodes] AS [UserBranches]
		ON [Users].[BranchCode] = [UserBranches].[Code]
		WHERE [Users].[ID] = @UserID;
		
		IF @DeskCode IS NOT NULL BEGIN
			INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
			SELECT [AppliedPermissions].[ID], 'Desk', [desk].[code], [desk].[name], [Configured]
			FROM [dbo].[AppliedPermissions]
			INNER JOIN [dbo].[desk]
			ON [desk].[code] = [AppliedPermissions].[DeskCode]
			WHERE [AppliedPermissions].[PermissionID] = @PermissionID
			AND [desk].[code] = @DeskCode;
			
			IF @@ROWCOUNT = 0 AND @TeamID IS NOT NULL BEGIN
				INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
				SELECT [AppliedPermissions].[ID], 'Team', [Teams].[ID], [Teams].[Name], [AppliedPermissions].[Configured]
				FROM [dbo].[AppliedPermissions]
				INNER JOIN [dbo].[Teams]
				ON [Teams].[ID] = [AppliedPermissions].[TeamID]
				WHERE [AppliedPermissions].[PermissionID] = @PermissionID
				AND [Teams].[ID] = @TeamID;
					
				IF @@ROWCOUNT = 0 AND @DepartmentID IS NOT NULL BEGIN
					INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
					SELECT [AppliedPermissions].[ID], 'Department', [Departments].[ID], [Departments].[Name], [AppliedPermissions].[Configured]
					FROM [dbo].[AppliedPermissions]
					INNER JOIN [dbo].[Departments]
					ON [Departments].[ID] = [AppliedPermissions].[DepartmentID]
					WHERE [AppliedPermissions].[PermissionID] = @PermissionID
					AND [Departments].[ID] = @DepartmentID;
							
					IF @@ROWCOUNT = 0 AND @DeskBranch IS NOT NULL BEGIN
						INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
						SELECT [AppliedPermissions].[ID], 'Branch', [BranchCodes].[Code], [BranchCodes].[Name], [AppliedPermissions].[Configured]
						FROM [dbo].[AppliedPermissions]
						INNER JOIN [dbo].[BranchCodes]
						ON [BranchCodes].[Code] = [AppliedPermissions].[BranchCode]
						WHERE [AppliedPermissions].[PermissionID] = @PermissionID
						AND [BranchCodes].[Code] = @DeskBranch;
					END;
				END;
			END;
		END;
		
		IF @UserBranch IS NOT NULL AND (@DeskBranch IS NULL OR @UserBranch <> @DeskBranch) BEGIN
			INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
			SELECT [AppliedPermissions].[ID], 'Branch', [BranchCodes].[Code], [BranchCodes].[Name], [AppliedPermissions].[Configured]
			FROM [dbo].[AppliedPermissions]
			INNER JOIN [dbo].[BranchCodes]
			ON [BranchCodes].[Code] = [AppliedPermissions].[BranchCode]
			WHERE [AppliedPermissions].[PermissionID] = @PermissionID
			AND [BranchCodes].[Code] = @UserBranch;
		END;

		IF @RoleID IS NOT NULL BEGIN
			INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
			SELECT [AppliedPermissions].[ID], 'Role', [Roles].[ID], [Roles].[RoleName], [AppliedPermissions].[Configured]
			FROM [dbo].[AppliedPermissions]
			INNER JOIN [dbo].[Roles]
			ON [Roles].[ID] = [AppliedPermissions].[RoleID]
			WHERE [AppliedPermissions].[PermissionID] = @PermissionID
			AND [Roles].[ID] = @RoleID;
		END;
	END;
END;

IF @CustomerCode IS NOT NULL BEGIN
	INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
	SELECT [AppliedPermissions].[ID], 'Customer', [customer].[customer], [customer].[name], [AppliedPermissions].[Configured]
	FROM [dbo].[AppliedPermissions]
	INNER JOIN [dbo].[customer]
	ON [customer].[customer] = [AppliedPermissions].[CustomerCode]
	WHERE [AppliedPermissions].[PermissionID] = @PermissionID
	AND [customer].[customer] = @CustomerCode;

	IF @@ROWCOUNT = 0 BEGIN
		INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
		SELECT [AppliedPermissions].[ID], 'Customer Group', [CustomCustGroups].[ID], [CustomCustGroups].[Name], [AppliedPermissions].[Configured]
		FROM [dbo].[AppliedPermissions]
		INNER JOIN [dbo].[Fact]
		ON [AppliedPermissions].[CustomGroupID] = [Fact].[CustomGroupID]
		INNER JOIN [dbo].[CustomCustGroups]
		ON [CustomCustGroups].[ID] = [Fact].[CustomGroupID]
		WHERE [AppliedPermissions].[PermissionID] = @PermissionID
		AND [Fact].[CustomerID] = @CustomerCode
		AND [Fact].[CustomGroupID] IS NOT NULL;
		
		INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
		SELECT [AppliedPermissions].[ID], 'Business Class', [COB].[Code], [COB].[Description], [AppliedPermissions].[Configured]
		FROM [dbo].[AppliedPermissions]
		INNER JOIN [dbo].[COB]
		ON [AppliedPermissions].[ClassCode] = [COB].[Code]
		INNER JOIN [dbo].[vCustomerCOB]
		ON [COB].[Code] = [vCustomerCOB].[COB]
		WHERE [AppliedPermissions].[PermissionID] = @PermissionID
		AND [vCustomerCOB].[Customer] = @CustomerCode;
	END;
END;

IF NOT EXISTS (SELECT * FROM @Effective) BEGIN
	INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
	SELECT [ID], 'System', 'System', 'System', [Configured]
	FROM [dbo].[AppliedPermissions]
	WHERE [PermissionID] = @PermissionID
	AND [RoleID] IS NULL
	AND [UserID] IS NULL
	AND [BranchCode] IS NULL
	AND [DepartmentID] IS NULL
	AND [TeamID] IS NULL
	AND [DeskCode] IS NULL
	AND [CustomerCode] IS NULL
	AND [CustomGroupID] IS NULL;

	IF @@ROWCOUNT = 0
		INSERT INTO @Effective ([ID], [Scope], [AppliedTo], [Description], [Configured])
		VALUES (NULL, 'System', 'Default', 'Default', 0);
END;

IF EXISTS (SELECT * FROM @Effective WHERE [Configured] = 0) BEGIN
	SET @Configured = 0;
END;
ELSE BEGIN
	SET @Configured = 1;
END;

SELECT [Effective].[ID], [Effective].[Scope], [Effective].[AppliedTo], [Effective].[Description], [Effective].[Configured] AS [Configured], [Permissions].[PolicyTemplate], [AppliedPermissions].[PolicySettings]
FROM @Effective AS [Effective]
INNER JOIN [dbo].[AppliedPermissions]
ON [AppliedPermissions].[ID] = [Effective].[ID]
INNER JOIN [dbo].[Permissions]
ON [AppliedPermissions].[PermissionID] = [Permissions].[ID]
ORDER BY [EffectiveID] DESC;

RETURN 0;
GO
GRANT EXECUTE ON  [dbo].[Policies_GetAppliedPermissions] TO [db_latitude]
GO
