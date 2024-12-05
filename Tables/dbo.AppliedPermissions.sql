CREATE TABLE [dbo].[AppliedPermissions]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RoleID] [int] NULL,
[UserID] [int] NULL,
[BranchCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartmentID] [int] NULL,
[TeamID] [int] NULL,
[DeskCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomGroupID] [int] NULL,
[CustomerCode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PermissionID] [int] NOT NULL,
[Configured] [bit] NOT NULL CONSTRAINT [DF__AppliedPe__Confi__24A9174F] DEFAULT (0),
[PolicySettings] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [int] NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF__AppliedPe__Modif__259D3B88] DEFAULT (getdate()),
[ClassCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [chk_AppliedPermissions_IDs] CHECK (([RoleID] IS NULL AND [UserID] IS NULL AND [BranchCode] IS NULL AND [DepartmentID] IS NULL AND [TeamID] IS NULL AND [DeskCode] IS NULL AND [CustomGroupID] IS NULL AND [CustomerCode] IS NULL AND [ClassCode] IS NULL OR [RoleID] IS NOT NULL AND [UserID] IS NULL AND [BranchCode] IS NULL AND [DepartmentID] IS NULL AND [TeamID] IS NULL AND [DeskCode] IS NULL AND [CustomGroupID] IS NULL AND [CustomerCode] IS NULL AND [ClassCode] IS NULL OR [RoleID] IS NULL AND [UserID] IS NOT NULL AND [BranchCode] IS NULL AND [DepartmentID] IS NULL AND [TeamID] IS NULL AND [DeskCode] IS NULL AND [CustomGroupID] IS NULL AND [CustomerCode] IS NULL AND [ClassCode] IS NULL OR [RoleID] IS NULL AND [UserID] IS NULL AND [BranchCode] IS NOT NULL AND [DepartmentID] IS NULL AND [TeamID] IS NULL AND [DeskCode] IS NULL AND [CustomGroupID] IS NULL AND [CustomerCode] IS NULL AND [ClassCode] IS NULL OR [RoleID] IS NULL AND [UserID] IS NULL AND [BranchCode] IS NULL AND [DepartmentID] IS NOT NULL AND [TeamID] IS NULL AND [DeskCode] IS NULL AND [CustomGroupID] IS NULL AND [CustomerCode] IS NULL AND [ClassCode] IS NULL OR [RoleID] IS NULL AND [UserID] IS NULL AND [BranchCode] IS NULL AND [DepartmentID] IS NULL AND [TeamID] IS NOT NULL AND [DeskCode] IS NULL AND [CustomGroupID] IS NULL AND [CustomerCode] IS NULL AND [ClassCode] IS NULL OR [RoleID] IS NULL AND [UserID] IS NULL AND [BranchCode] IS NULL AND [DepartmentID] IS NULL AND [TeamID] IS NULL AND [DeskCode] IS NOT NULL AND [CustomGroupID] IS NULL AND [CustomerCode] IS NULL AND [ClassCode] IS NULL OR [RoleID] IS NULL AND [UserID] IS NULL AND [BranchCode] IS NULL AND [DepartmentID] IS NULL AND [TeamID] IS NULL AND [DeskCode] IS NULL AND [CustomGroupID] IS NOT NULL AND [CustomerCode] IS NULL AND [ClassCode] IS NULL OR [RoleID] IS NULL AND [UserID] IS NULL AND [BranchCode] IS NULL AND [DepartmentID] IS NULL AND [TeamID] IS NULL AND [DeskCode] IS NULL AND [CustomGroupID] IS NULL AND [CustomerCode] IS NOT NULL AND [ClassCode] IS NULL OR [RoleID] IS NULL AND [UserID] IS NULL AND [BranchCode] IS NULL AND [DepartmentID] IS NULL AND [TeamID] IS NULL AND [DeskCode] IS NULL AND [CustomGroupID] IS NULL AND [CustomerCode] IS NULL AND [ClassCode] IS NOT NULL))
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [pk_AppliedPermissions] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AppliedPermissions_PermissionID] ON [dbo].[AppliedPermissions] ([PermissionID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AppliedPermissions_BranchCode] ON [dbo].[AppliedPermissions] ([PermissionID], [BranchCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AppliedPermissions_ClassCode] ON [dbo].[AppliedPermissions] ([PermissionID], [ClassCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AppliedPermissions_CustomerCode] ON [dbo].[AppliedPermissions] ([PermissionID], [CustomerCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AppliedPermissions_CustomGroupID] ON [dbo].[AppliedPermissions] ([PermissionID], [CustomGroupID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AppliedPermissions_DepartmentID] ON [dbo].[AppliedPermissions] ([PermissionID], [DepartmentID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AppliedPermissions_DeskCode] ON [dbo].[AppliedPermissions] ([PermissionID], [DeskCode]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AppliedPermissions_RoleID] ON [dbo].[AppliedPermissions] ([PermissionID], [RoleID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AppliedPermissions_TeamID] ON [dbo].[AppliedPermissions] ([PermissionID], [TeamID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AppliedPermissions_UserID] ON [dbo].[AppliedPermissions] ([PermissionID], [UserID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [uq_AppliedPermissions_PermissionID] UNIQUE NONCLUSTERED ([RoleID], [UserID], [BranchCode], [DepartmentID], [TeamID], [DeskCode], [ClassCode], [CustomGroupID], [CustomerCode], [PermissionID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [fk_AppliedPermissions_Branches] FOREIGN KEY ([BranchCode]) REFERENCES [dbo].[BranchCodes] ([Code]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [fk_AppliedPermissions_Customers] FOREIGN KEY ([CustomerCode]) REFERENCES [dbo].[Customer] ([customer]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [fk_AppliedPermissions_CustomGroups] FOREIGN KEY ([CustomGroupID]) REFERENCES [dbo].[CustomCustGroups] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [fk_AppliedPermissions_Departments] FOREIGN KEY ([DepartmentID]) REFERENCES [dbo].[Departments] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [fk_AppliedPermissions_Desks] FOREIGN KEY ([DeskCode]) REFERENCES [dbo].[desk] ([code]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [fk_AppliedPermissions_ModifiedUser] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [fk_AppliedPermissions_Permissions] FOREIGN KEY ([PermissionID]) REFERENCES [dbo].[Permissions] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [fk_AppliedPermissions_Roles] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Roles] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [fk_AppliedPermissions_Teams] FOREIGN KEY ([TeamID]) REFERENCES [dbo].[Teams] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AppliedPermissions] ADD CONSTRAINT [fk_AppliedPermissions_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used by the Latitude Permissions and Policies Editor to assign user rights for access to latitude application components.', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branchcode User and Desk belongs to', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'BranchCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set turns permission on', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'Configured'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'CustomerCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CustomGroup respective Customer belongs to', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'CustomGroupID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DepartmentID of parent Department that User belongs to', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'DepartmentID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DeskCode user is assigned to', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'DeskCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'UserID of user defining or updating the permission', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Permission ID of parent permission', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'PermissionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Policy setting string', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'PolicySettings'
GO
EXEC sp_addextendedproperty N'MS_Description', N'RoleID of parent Roles', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'RoleID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'TeamID User belongs to', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'TeamID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'UserID of parent Users, the user id that the respective permission is applied', 'SCHEMA', N'dbo', 'TABLE', N'AppliedPermissions', 'COLUMN', N'UserID'
GO
