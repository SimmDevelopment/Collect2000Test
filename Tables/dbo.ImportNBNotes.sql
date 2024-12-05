CREATE TABLE [dbo].[ImportNBNotes]
(
[number] [int] NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created] [datetime] NULL,
[user0] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[action] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[result] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seq] [int] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table for NewBusiness load', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBNotes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Action Code', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBNotes', 'COLUMN', N'action'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Text freeform comment', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBNotes', 'COLUMN', N'comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Note was created', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBNotes', 'COLUMN', N'created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBNotes', 'COLUMN', N'ctl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique file number related to Master.number', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBNotes', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Result Code', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBNotes', 'COLUMN', N'result'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that Created the Note', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBNotes', 'COLUMN', N'user0'
GO
