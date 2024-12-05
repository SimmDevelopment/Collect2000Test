CREATE TABLE [dbo].[ImportCustomerNotes]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[BatchID] [int] NOT NULL,
[ImportAcctID] [int] NOT NULL,
[NoteDate] [datetime] NOT NULL,
[NoteText] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImportCustomerNotes] ADD CONSTRAINT [PK_ImportCustomerNotes] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table used by Import Excel', 'SCHEMA', N'dbo', 'TABLE', N'ImportCustomerNotes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Batch Identity of Import', 'SCHEMA', N'dbo', 'TABLE', N'ImportCustomerNotes', 'COLUMN', N'BatchID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportCustomerNotes', 'COLUMN', N'ImportAcctID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp original note created', 'SCHEMA', N'dbo', 'TABLE', N'ImportCustomerNotes', 'COLUMN', N'NoteDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free form note text', 'SCHEMA', N'dbo', 'TABLE', N'ImportCustomerNotes', 'COLUMN', N'NoteText'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'ImportCustomerNotes', 'COLUMN', N'UID'
GO
