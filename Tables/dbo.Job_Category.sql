CREATE TABLE [dbo].[Job_Category]
(
[ID] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Job_Category] ADD CONSTRAINT [PK_Job_Category] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job Category Definition Table', 'SCHEMA', N'dbo', 'TABLE', N'Job_Category', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'Job_Category', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of Category', 'SCHEMA', N'dbo', 'TABLE', N'Job_Category', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Job_Category', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity ID', 'SCHEMA', N'dbo', 'TABLE', N'Job_Category', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Job_Category', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of Category', 'SCHEMA', N'dbo', 'TABLE', N'Job_Category', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Job_Category', 'COLUMN', N'Name'
GO
