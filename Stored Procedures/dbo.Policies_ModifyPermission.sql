SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_ModifyPermission] @AppliedID INTEGER, @Configured BIT, @PolicySettings TEXT, @ModifiedUserID INTEGER
AS
SET NOCOUNT ON;

IF @AppliedID IS NULL OR NOT EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [ID] = @AppliedID) BEGIN
	RAISERROR('Applied permission does not exist.', 16, 1);
	RETURN 1;
END;

IF @Configured IS NULL
	SET @Configured = 0;

DECLARE @ModifiedDate DATETIME;
SET @ModifiedDate = GETDATE();

IF @ModifiedUserID = 0
	SET @ModifiedUserID = NULL;

DECLARE @PermissionID INTEGER;
DECLARE @RoleID INTEGER;
DECLARE @UserID INTEGER;
DECLARE @BranchCode VARCHAR(5);
DECLARE @DepartmentID INTEGER;
DECLARE @TeamID INTEGER;
DECLARE @DeskCode VARCHAR(10);
DECLARE @ClassCode VARCHAR(5);
DECLARE @CustomGroupID INTEGER;
DECLARE @CustomerCode VARCHAR(7);
DECLARE @OldConfigured BIT;
DECLARE @OldPolicySettings NVARCHAR(4000);

UPDATE [dbo].[AppliedPermissions]
SET @PermissionID = [PermissionID],
	@RoleID = [RoleID],
	@UserID = [UserID],
	@BranchCode = [BranchCode],
	@DepartmentID = [DepartmentID],
	@TeamID = [TeamID],
	@DeskCode = [DeskCode],
	@ClassCode = [ClassCode],
	@CustomGroupID = [CustomGroupID],
	@CustomerCode = [CustomerCode],
	@OldConfigured = [Configured],
	[Configured] = @Configured,
	@OldPolicySettings = SUBSTRING([PolicySettings], 1, 4000),
	[PolicySettings] = @PolicySettings,
	[ModifiedBy] = @ModifiedUserID,
	[ModifiedDate] = @ModifiedDate
WHERE [ID] = @AppliedID;

IF @@ERROR != 0 BEGIN
	RETURN 1;
END;

INSERT INTO [dbo].[AppliedPermissionsAudit] ([PermissionID], [RoleID], [UserID], [BranchCode], [DepartmentID], [TeamID], [DeskCode], [ClassCode], [CustomGroupID], [CustomerCode], [OldConfigured], [NewConfigured], [OldPolicySettings], [NewPolicySettings], [ModifiedBy], [ModifiedDate])
VALUES (@PermissionID, @RoleID, @UserID, @BranchCode, @DepartmentID, @TeamID, @DeskCode, @ClassCode, @CustomGroupID, @CustomerCode, @OldConfigured, @Configured, @OldPolicySettings, @PolicySettings, @ModifiedUserID, @ModifiedDate);

RETURN 0;

GO
