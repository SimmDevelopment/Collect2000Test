CREATE TABLE [dbo].[ArchiveHistory]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[Created] [datetime] NOT NULL CONSTRAINT [DF__ArchiveHi__Creat__5AB4E64F] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__ArchiveHi__Creat__5BA90A88] DEFAULT (suser_sname()),
[ArchiveAction] [tinyint] NOT NULL CONSTRAINT [DF__ArchiveHi__Archi__5C9D2EC1] DEFAULT ((0)),
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ArchiveHistory] ADD CONSTRAINT [PK_ArchiveHistory] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 --> Comment only, 1 --> Serious Error/Warning, 2 --> Configuration Changed, 4 --> Database object created or modified, 8 --> Data Archived, 16 --> Data Restored, 32 --> Error Archiving data, 64 --> Error Restoring data', 'SCHEMA', N'dbo', 'TABLE', N'ArchiveHistory', 'COLUMN', N'ArchiveAction'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A description of the action that this record represents. An error message, sql statement, list of values, etc.', 'SCHEMA', N'dbo', 'TABLE', N'ArchiveHistory', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime this record was created.', 'SCHEMA', N'dbo', 'TABLE', N'ArchiveHistory', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude user that created record.', 'SCHEMA', N'dbo', 'TABLE', N'ArchiveHistory', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK Unique Identity', 'SCHEMA', N'dbo', 'TABLE', N'ArchiveHistory', 'COLUMN', N'UID'
GO
