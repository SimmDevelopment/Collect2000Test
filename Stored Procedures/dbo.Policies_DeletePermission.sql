SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Policies_DeletePermission] @AppliedID INTEGER, @ModifiedUserID INTEGER
AS
SET NOCOUNT ON;

IF @AppliedID IS NULL OR NOT EXISTS (SELECT * FROM [dbo].[AppliedPermissions] WHERE [ID] = @AppliedID) BEGIN
	RAISERROR('Applied permission does not exist.', 16, 1);
	RETURN 1;
END;

DECLARE @ModifiedDate DATETIME;
SET @ModifiedDate = GETDATE();

IF @ModifiedUserID = 0
	SET @ModifiedUserID = NULL;

BEGIN TRANSACTION;

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

SELECT @PermissionID = [PermissionID],
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
	@OldPolicySettings = SUBSTRING([PolicySettings], 1, 4000)
FROM [dbo].[AppliedPermissions]
WHERE [ID] = @AppliedID;

DELETE FROM [dbo].[AppliedPermissions]
WHERE [ID] = @AppliedID;

IF @@ERROR != 0 BEGIN
	ROLLBACK TRANSACTION;
	RETURN 1;
END;

INSERT INTO [dbo].[AppliedPermissionsAudit] ([PermissionID], [RoleID], [UserID], [BranchCode], [DepartmentID], [TeamID], [DeskCode], [ClassCode], [CustomGroupID], [CustomerCode], [OldConfigured], [NewConfigured], [OldPolicySettings], [NewPolicySettings], [ModifiedBy], [ModifiedDate])
VALUES (@PermissionID, @RoleID, @UserID, @BranchCode, @DepartmentID, @TeamID, @DeskCode, @ClassCode, @CustomGroupID, @CustomerCode, @OldConfigured, NULL, @OldPolicySettings, NULL, @ModifiedUserID, @ModifiedDate);

COMMIT TRANSACTION;

RETURN 0;

GO
