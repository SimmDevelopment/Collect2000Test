CREATE TABLE [dbo].[ImportNBCustomerNotes]
(
[Number] [int] NULL,
[Seq] [int] NULL,
[NoteDate] [datetime] NULL,
[NoteText] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table for NewBusiness load', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBCustomerNotes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp Note created', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBCustomerNotes', 'COLUMN', N'NoteDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free Form Note Text', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBCustomerNotes', 'COLUMN', N'NoteText'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBCustomerNotes', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Note Sequence', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBCustomerNotes', 'COLUMN', N'Seq'
GO
