CREATE TABLE [dbo].[WebAccess_Reports]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ReportName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportKey] [uniqueidentifier] NULL,
[ShownInMenu] [bit] NULL CONSTRAINT [DF__WebAccess__Shown__4C079F9C] DEFAULT ((1)),
[Context] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportDefinition] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WebAccess_Reports] ADD CONSTRAINT [PK__WebAccess_Reports] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'WebAccess_Reports', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'WebAccess_Reports', 'COLUMN', N'Category'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'WebAccess_Reports', 'COLUMN', N'Context'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'WebAccess_Reports', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'WebAccess_Reports', 'COLUMN', N'FileName'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'WebAccess_Reports', 'COLUMN', N'ReportDefinition'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'WebAccess_Reports', 'COLUMN', N'ReportKey'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'WebAccess_Reports', 'COLUMN', N'ShownInMenu'
GO
