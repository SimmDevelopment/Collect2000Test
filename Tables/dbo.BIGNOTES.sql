CREATE TABLE [dbo].[BIGNOTES]
(
[NUMBER] [int] NOT NULL,
[BIGNOTE] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BIGNOTES] ADD CONSTRAINT [PK_BIGNOTES] PRIMARY KEY NONCLUSTERED ([NUMBER]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'A big note is basically a large window that allows you to enter free form notes on an account. Only one big note window is attached to each account, but you may add or remove information as needed each time the account is accessed. Big note information will not appear in the Notes window at the bottom of the work form. This is not a transaction record.  Updates overwrite the column.', 'SCHEMA', N'dbo', 'TABLE', N'BIGNOTES', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free form text field', 'SCHEMA', N'dbo', 'TABLE', N'BIGNOTES', 'COLUMN', N'BIGNOTE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'BIGNOTES', 'COLUMN', N'NUMBER'
GO
