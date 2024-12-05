CREATE TABLE [dbo].[Departments]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Branch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ManagerID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Departments] ADD CONSTRAINT [PK__Departments__0F4ED30D] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Departments] ADD CONSTRAINT [UQ__Departments__1042F746] UNIQUE NONCLUSTERED ([Name]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Departments] ADD CONSTRAINT [FK__Departmen__Branc__11371B7F] FOREIGN KEY ([Branch]) REFERENCES [dbo].[BranchCodes] ([Code])
GO
ALTER TABLE [dbo].[Departments] ADD CONSTRAINT [FK__Departmen__Manag__122B3FB8] FOREIGN KEY ([ManagerID]) REFERENCES [dbo].[Users] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Departments are assigned to a specific branch and are used for defining permissions and as a category within the Management Dashboard', 'SCHEMA', N'dbo', 'TABLE', N'Departments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent Branch Code', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'Branch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Identity Key for respective manager', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'ManagerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Department Name', 'SCHEMA', N'dbo', 'TABLE', N'Departments', 'COLUMN', N'Name'
GO
