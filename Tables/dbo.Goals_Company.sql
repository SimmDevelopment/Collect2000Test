CREATE TABLE [dbo].[Goals_Company]
(
[GoalsCompanyID] [uniqueidentifier] NOT NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TreePath] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentID] [uniqueidentifier] NULL,
[GoalType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Goals_Company] ADD CONSTRAINT [PK_Goals_Company] PRIMARY KEY CLUSTERED ([GoalsCompanyID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Goals_Company', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Goals_Company', 'COLUMN', N'GoalsCompanyID'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Goals_Company', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Data', 'SCHEMA', N'dbo', 'TABLE', N'Goals_Company', 'COLUMN', N'ParentID'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Goals_Company', 'COLUMN', N'TreePath'
GO
