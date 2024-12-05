CREATE TABLE [dbo].[NBCustomerNotes]
(
[Number] [int] NOT NULL,
[Seq] [int] NULL,
[NoteDate] [smalldatetime] NULL,
[NoteText] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Row Inserted', 'SCHEMA', N'dbo', 'TABLE', N'NBCustomerNotes', 'COLUMN', N'NoteDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Note data', 'SCHEMA', N'dbo', 'TABLE', N'NBCustomerNotes', 'COLUMN', N'NoteText'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'NBCustomerNotes', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Note Sequence number', 'SCHEMA', N'dbo', 'TABLE', N'NBCustomerNotes', 'COLUMN', N'Seq'
GO
