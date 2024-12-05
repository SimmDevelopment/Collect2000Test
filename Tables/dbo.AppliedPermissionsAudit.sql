CREATE TABLE [dbo].[AppliedPermissionsAudit]
(
[UID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__AppliedPerm__UID__237FE8EC] DEFAULT (newid()),
[PermissionID] [int] NOT NULL,
[RoleID] [int] NULL,
[UserID] [int] NULL,
[BranchCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartmentID] [int] NULL,
[TeamID] [int] NULL,
[DeskCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomGroupID] [int] NULL,
[CustomerCode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OldConfigured] [bit] NULL,
[NewConfigured] [bit] NULL,
[OldPolicySettings] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewPolicySettings] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NOT NULL,
[ClassCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppliedPermissionsAudit] ADD CONSTRAINT [pk_AppliedPermissionsAudit] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Permissions audit table that logs all permission changes.', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branchcode User and Desk belongs to', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'BranchCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'CustomerCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CustomGroup respective Customer belongs to', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'CustomGroupID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DepartmentID of parent Department that User belongs to', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'DepartmentID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DeskCode user is assigned to', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'DeskCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'UserID of user defining or updating the permission', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New configuration setting', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'NewConfigured'
GO
EXEC sp_addextendedproperty N'MS_Description', N'New policy settings', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'NewPolicySettings'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Previous configuration setting', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'OldConfigured'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Old policy settings', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'OldPolicySettings'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Permission ID of parent permission', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'PermissionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'RoleID of parent Roles', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'RoleID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'TeamID User belongs to', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'TeamID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identifier for audit entry', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'UserID of parent Users, the user id that the respective permission is applied', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissionsAudit', 'COLUMN', N'UserID'
GO
