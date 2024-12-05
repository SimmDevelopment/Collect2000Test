SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_ApplyPermission] @PermissionID INTEGER, @Scope VARCHAR(25), @ApplyTo SQL_VARIANT, @Configured BIT, @PolicySettings TEXT, @ModifiedUserID INTEGER, @AppliedID INTEGER OUTPUT
AS
SET NOCOUNT ON;

IF @PermissionID IS NULL OR NOT EXISTS (SELECT * FROM [dbo].[Permissions] WHERE [ID] = @PermissionID) BEGIN
	RAISERROR('Permission does not exist.', 16, 1);
	RETURN 1;
END;

DECLARE @UserPermission BIT;
DECLARE @CustomerPermission BIT;
DECLARE @DeskPermission BIT;

SELECT @UserPermission = [UserPermission],
	@CustomerPermission = [CustomerPermission],
	@DeskPermission = [DeskPermission]
FROM [dbo].[Permissions]
WHERE [Permissions].[ID] = @PermissionID;

IF @Configured IS NULL
	SET @Configured = 0;

IF @Scope IS NULL
	SET @Scope = 'System';

DECLARE @RoleID INTEGER;
DECLARE @UserID INTEGER;
DECLARE @BranchCode VARCHAR(5);
DECLARE @DepartmentID INTEGER;
DECLARE @TeamID INTEGER;
DECLARE @DeskCode VARCHAR(10);
DECLARE @ClassCode VARCHAR(5);
DECLARE @CustomGroupID INTEGER;
DECLARE @CustomerCode VARCHAR(7);

SET @RoleID = NULL;
SET @UserID = NULL;
SET @BranchCode = NULL;
SET @DepartmentID = NULL;
SET @TeamID = NULL;
SET @DeskCode = NULL;
SET @ClassCode = NULL;
SET @CustomGroupID = NULL;
SET @CustomerCode = NULL;

IF @Scope != 'System' AND @ApplyTo IS NULL BEGIN
	RAISERROR('@ApplyTo cannot be NULL unless @Scope is "System".', 16, 1);
	RETURN 1;
END;
ELSE IF @Scope = 'System' BEGIN
	IF EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [PermissionID] = @PermissionID AND [RoleID] IS NULL AND [UserID] IS NULL AND [BranchCode] IS NULL AND [DepartmentID] IS NULL AND [TeamID] IS NULL AND [DeskCode] IS NULL AND [CustomGroupID] IS NULL AND [CustomerCode] IS NULL AND [ClassCode] IS NULL) BEGIN
		RAISERROR('Permission is already applied for system.', 16, 1);
		RETURN 1;
	END;
END;
ELSE IF @Scope = 'Role' BEGIN
	IF SQL_VARIANT_PROPERTY(@ApplyTo, 'BaseType') NOT IN ('int', 'smallint', 'tinyint', 'bigint') BEGIN
		RAISERROR('@ApplyTo contains an invalid value.', 16, 1);
		RETURN 1;
	END;
	SET @RoleID = CAST(@ApplyTo AS INTEGER);
	IF NOT EXISTS (SELECT * FROM [dbo].[Roles] WHERE [ID] = @RoleID) BEGIN
		RAISERROR('Role ID %d does not exist.', 16, 1, @RoleID);
		RETURN 1;
	END;
	IF @UserPermission = 0 BEGIN
		RAISERROR('Permission cannot be applied to role.', 16, 1);
		RETURN 1;
	END;
	IF EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [PermissionID] = @PermissionID AND [RoleID] = @RoleID) BEGIN
		RAISERROR('Permission is already applied for role.', 16, 1);
		RETURN 1;
	END;
END;
ELSE IF @Scope = 'User' BEGIN
	IF SQL_VARIANT_PROPERTY(@ApplyTo, 'BaseType') NOT IN ('int', 'smallint', 'tinyint', 'bigint') BEGIN
		RAISERROR('@ApplyTo contains an invalid value.', 16, 1);
		RETURN 1;
	END;
	SET @UserID = CAST(@ApplyTo AS INTEGER);
	IF NOT EXISTS (SELECT * FROM [dbo].[Users] WHERE [ID] = @UserID AND [Active] = 1) BEGIN
		RAISERROR('User ID %d does not exist or is not active.', 16, 1, @UserID);
		RETURN 1;
	END;
	IF @UserPermission = 0 BEGIN
		RAISERROR('Permission cannot be applied to user.', 16, 1);
		RETURN 1;
	END;
	IF EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [PermissionID] = @PermissionID AND [UserID] = @UserID) BEGIN
		RAISERROR('Permission is already applied for user.', 16, 1);
		RETURN 1;
	END;
END;
ELSE IF @Scope = 'Branch' BEGIN
	IF SQL_VARIANT_PROPERTY(@ApplyTo, 'BaseType') NOT IN ('char', 'nchar', 'varchar', 'nvarchar') BEGIN
		RAISERROR('@ApplyTo contains an invalid value.', 16, 1);
		RETURN 1;
	END;
	SET @BranchCode = SUBSTRING(CAST(@ApplyTo AS VARCHAR(8000)), 1, 5);
	IF NOT EXISTS (SELECT * FROM [dbo].[BranchCodes] WHERE [Code] = @BranchCode) BEGIN
		RAISERROR('Branch code "%s" does not exist.', 16, 1, @BranchCode);
		RETURN 1;
	END;
	IF EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [PermissionID] = @PermissionID AND [BranchCode] = @BranchCode) BEGIN
		RAISERROR('Permission is already applied for branch.', 16, 1);
		RETURN 1;
	END;
END;
ELSE IF @Scope = 'Department' BEGIN
	IF SQL_VARIANT_PROPERTY(@ApplyTo, 'BaseType') NOT IN ('int', 'smallint', 'tinyint', 'bigint') BEGIN
		RAISERROR('@ApplyTo contains an invalid value.', 16, 1);
		RETURN 1;
	END;
	SET @DepartmentID = CAST(@ApplyTo AS INTEGER);
	IF NOT EXISTS (SELECT * FROM [dbo].[Departments] WHERE [ID] = @DepartmentID) BEGIN
		RAISERROR('Department %d does not exist.', 16, 1, @DepartmentID);
		RETURN 1;
	END;
	IF @DeskPermission = 0 BEGIN
		RAISERROR('Permission cannot be applied to department.', 16, 1);
		RETURN 1;
	END;
	IF EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [PermissionID] = @PermissionID AND [DepartmentID] = @DepartmentID) BEGIN
		RAISERROR('Permission is already applied for department.', 16, 1);
		RETURN 1;
	END;
END;
ELSE IF @Scope = 'Team' BEGIN
	IF SQL_VARIANT_PROPERTY(@ApplyTo, 'BaseType') NOT IN ('int', 'smallint', 'tinyint', 'bigint') BEGIN
		RAISERROR('@ApplyTo contains an invalid value.', 16, 1);
		RETURN 1;
	END;
	SET @TeamID = CAST(@ApplyTo AS INTEGER);
	IF NOT EXISTS (SELECT * FROM [dbo].[Teams] WHERE [ID] = @TeamID) BEGIN
		RAISERROR('Team %d does not exist.', 16, 1, @TeamID);
		RETURN 1;
	END;
	IF @DeskPermission = 0 BEGIN
		RAISERROR('Permission cannot be applied to team.', 16, 1);
		RETURN 1;
	END;
	IF EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [PermissionID] = @PermissionID AND [TeamID] = @TeamID) BEGIN
		RAISERROR('Permission is already applied for team.', 16, 1);
		RETURN 1;
	END;
END;
ELSE IF @Scope = 'Desk' BEGIN
	IF SQL_VARIANT_PROPERTY(@ApplyTo, 'BaseType') NOT IN ('char', 'nchar', 'varchar', 'nvarchar') BEGIN
		RAISERROR('@ApplyTo contains an invalid value.', 16, 1);
		RETURN 1;
	END;
	SET @DeskCode = SUBSTRING(CAST(@ApplyTo AS VARCHAR(8000)), 1, 10);
	IF NOT EXISTS (SELECT * FROM [dbo].[desk] WHERE [code] = @DeskCode) BEGIN
		RAISERROR('Desk code "%s" does not exist.', 16, 1, @DeskCode);
		RETURN 1;
	END;
	IF @DeskPermission = 0 BEGIN
		RAISERROR('Permission cannot be applied to desk.', 16, 1);
		RETURN 1;
	END;
	IF EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [PermissionID] = @PermissionID AND [DeskCode] = @DeskCode) BEGIN
		RAISERROR('Permission is already applied for desk.', 16, 1);
		RETURN 1;
	END;
END;
ELSE IF @Scope = 'Business Class' BEGIN
	IF SQL_VARIANT_PROPERTY(@ApplyTo, 'BaseType') NOT IN ('char', 'nchar', 'varchar', 'nvarchar') BEGIN
		RAISERROR('@ApplyTo contains an invalid value.', 16, 1);
		RETURN 1;
	END;
	SET @ClassCode = SUBSTRING(CAST(@ApplyTo AS VARCHAR(8000)), 1, 5);
	IF NOT EXISTS (SELECT * FROM [dbo].[COB] WHERE [Code] = @ClassCode) BEGIN
		RAISERROR('Business Class code "%s" does not exist.', 16, 1, @ClassCode);
		RETURN 1;
	END;
	IF @CustomerPermission = 0 BEGIN
		RAISERROR('Permission cannot be applied to business class.', 16, 1);
		RETURN 1;
	END;
	IF EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [PermissionID] = @PermissionID AND [ClassCode] = @ClassCode) BEGIN
		RAISERROR('Permission is already applied for business class.', 16, 1);
		RETURN 1;
	END;
END;
ELSE IF @Scope = 'Customer Group' BEGIN
	IF SQL_VARIANT_PROPERTY(@ApplyTo, 'BaseType') NOT IN ('int', 'smallint', 'tinyint', 'bigint') BEGIN
		RAISERROR('@ApplyTo contains an invalid value.', 16, 1);
		RETURN 1;
	END;
	SET @CustomGroupID = CAST(@ApplyTo AS INTEGER);
	IF NOT EXISTS (SELECT * FROM [dbo].[CustomCustGroups] WHERE [ID] = @CustomGroupID) BEGIN
		RAISERROR('Customer group ID %d does not exist.', 16, 1, @CustomGroupID);
		RETURN 1;
	END;
	IF @CustomerPermission = 0 BEGIN
		RAISERROR('Permission cannot be applied to customer group.', 16, 1);
		RETURN 1;
	END;
	IF EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [PermissionID] = @PermissionID AND [CustomGroupID] = @CustomGroupID) BEGIN
		RAISERROR('Permission is already applied for customer group.', 16, 1);
		RETURN 1;
	END;
END;
ELSE IF @Scope = 'Customer' BEGIN
	IF SQL_VARIANT_PROPERTY(@ApplyTo, 'BaseType') NOT IN ('char', 'nchar', 'varchar', 'nvarchar') BEGIN
		RAISERROR('@ApplyTo contains an invalid value.', 16, 1);
		RETURN 1;
	END;
	SET @CustomerCode = SUBSTRING(CAST(@ApplyTo AS VARCHAR(8000)), 1, 7);
	IF NOT EXISTS (SELECT * FROM [dbo].[customer] WHERE [customer] = @CustomerCode) BEGIN
		RAISERROR('Customer code "%s" does not exist.', 16, 1, @CustomerCode);
		RETURN 1;
	END;
	IF @CustomerPermission = 0 BEGIN
		RAISERROR('Permission cannot be applied to customer.', 16, 1);
		RETURN 1;
	END;
	IF EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [PermissionID] = @PermissionID AND [CustomerCode] = @CustomerCode) BEGIN
		RAISERROR('Permission is already applied for customer.', 16, 1);
		RETURN 1;
	END;
END;
ELSE BEGIN
	RAISERROR('Scope "%s" is invalid, must be "System", "Role", "Branch", "Department", "Team", "Desk", "User", "Customer Group" or "Customer".', 16, 1, @Scope);
	RETURN 1;
END;

DECLARE @ModifiedDate DATETIME;
SET @ModifiedDate = GETDATE();

IF @ModifiedUserID = 0
	SET @ModifiedUserID = NULL;

INSERT INTO [dbo].[AppliedPermissions] ([RoleID], [UserID], [BranchCode], [DepartmentID], [TeamID], [DeskCode], [ClassCode], [CustomGroupID], [CustomerCode], [PermissionID], [Configured], [PolicySettings], [ModifiedBy], [ModifiedDate])
VALUES (@RoleID, @UserID, @BranchCode, @DepartmentID, @TeamID, @DeskCode, @ClassCode, @CustomGroupID, @CustomerCode, @PermissionID, @Configured, @PolicySettings, @ModifiedUserID, @ModifiedDate);

IF @@ERROR != 0 BEGIN
	RETURN 1;
END;

SET @AppliedID = SCOPE_IDENTITY();

INSERT INTO [dbo].[AppliedPermissionsAudit] ([PermissionID], [RoleID], [UserID], [BranchCode], [DepartmentID], [TeamID], [DeskCode], [ClassCode], [CustomGroupID], [CustomerCode], [OldConfigured], [NewConfigured], [OldPolicySettings], [NewPolicySettings], [ModifiedBy], [ModifiedDate])
VALUES (@PermissionID, @RoleID, @UserID, @BranchCode, @DepartmentID, @TeamID, @DeskCode, @ClassCode, @CustomGroupID, @CustomerCode, NULL, @Configured, NULL, @PolicySettings, @ModifiedUserID, @ModifiedDate);

RETURN 0;
GO
