CREATE TABLE [dbo].[CustomerNotes]
(
[Number] [int] NULL,
[Seq] [int] NULL,
[NoteDate] [datetime] NULL,
[NoteText] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CustomerNotes1] ON [dbo].[CustomerNotes] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Retains account specific notes provided by Customer and loaded by the Newbusiness load', 'SCHEMA', N'dbo', 'TABLE', N'CustomerNotes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime Entered', 'SCHEMA', N'dbo', 'TABLE', N'CustomerNotes', 'COLUMN', N'NoteDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Freeform Text Note', 'SCHEMA', N'dbo', 'TABLE', N'CustomerNotes', 'COLUMN', N'NoteText'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'CustomerNotes', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence number of note', 'SCHEMA', N'dbo', 'TABLE', N'CustomerNotes', 'COLUMN', N'Seq'
GO
