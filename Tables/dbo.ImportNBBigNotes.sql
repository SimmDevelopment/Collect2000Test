CREATE TABLE [dbo].[ImportNBBigNotes]
(
[NUMBER] [int] NULL,
[BIGNOTE] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table for NewBusiness load', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBBigNotes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free Form Text Note', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBBigNotes', 'COLUMN', N'BIGNOTE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBBigNotes', 'COLUMN', N'NUMBER'
GO
