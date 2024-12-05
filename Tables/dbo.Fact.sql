CREATE TABLE [dbo].[Fact]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CustomerID] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomGroupID] [int] NULL,
[DeskID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeskGroupID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RoleID] [int] NULL,
[PermissionID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Fact] ADD CONSTRAINT [PK_Fact] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Fact_RoleID] ON [dbo].[Fact] ([RoleID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Fact_RoleID_PermissionID] ON [dbo].[Fact] ([RoleID], [PermissionID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used to relate Customer to Customer groups and Roles to Permissions ', 'SCHEMA', N'dbo', 'TABLE', N'Fact', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'Fact', 'COLUMN', N'CustomerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CustomCustGroup Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Fact', 'COLUMN', N'CustomGroupID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identoty Key', 'SCHEMA', N'dbo', 'TABLE', N'Fact', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Permission Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Fact', 'COLUMN', N'PermissionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Role Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Fact', 'COLUMN', N'RoleID'
GO
