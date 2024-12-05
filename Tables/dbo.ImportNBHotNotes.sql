CREATE TABLE [dbo].[ImportNBHotNotes]
(
[Number] [int] NOT NULL,
[HotNote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table.  ', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBHotNotes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free form text note', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBHotNotes', 'COLUMN', N'HotNote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBHotNotes', 'COLUMN', N'Number'
GO
