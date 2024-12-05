CREATE TABLE [dbo].[ImportBigNotes]
(
[ImportAcctID] [int] NOT NULL,
[BigNote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImportBigNotes] ADD CONSTRAINT [PK_ImportBigNotes] PRIMARY KEY CLUSTERED ([ImportAcctID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table used by Import Excel', 'SCHEMA', N'dbo', 'TABLE', N'ImportBigNotes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free Form Text Note', 'SCHEMA', N'dbo', 'TABLE', N'ImportBigNotes', 'COLUMN', N'BigNote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportBigNotes', 'COLUMN', N'ImportAcctID'
GO
