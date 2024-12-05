CREATE TABLE [dbo].[ImportNotes]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[BatchID] [int] NOT NULL,
[ImportAcctID] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[UserID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActionCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ResultCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Comment] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImportNotes] ADD CONSTRAINT [PK_ImportNotes] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table used by Import Excel', 'SCHEMA', N'dbo', 'TABLE', N'ImportNotes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Action Code', 'SCHEMA', N'dbo', 'TABLE', N'ImportNotes', 'COLUMN', N'ActionCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Batch Identity of Import', 'SCHEMA', N'dbo', 'TABLE', N'ImportNotes', 'COLUMN', N'BatchID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Text freeform comment', 'SCHEMA', N'dbo', 'TABLE', N'ImportNotes', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Note was created', 'SCHEMA', N'dbo', 'TABLE', N'ImportNotes', 'COLUMN', N'CreatedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportNotes', 'COLUMN', N'ImportAcctID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Result Code', 'SCHEMA', N'dbo', 'TABLE', N'ImportNotes', 'COLUMN', N'ResultCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identifier assigned to each note row', 'SCHEMA', N'dbo', 'TABLE', N'ImportNotes', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that Created the Note', 'SCHEMA', N'dbo', 'TABLE', N'ImportNotes', 'COLUMN', N'UserID'
GO
