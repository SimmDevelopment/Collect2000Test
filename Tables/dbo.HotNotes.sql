CREATE TABLE [dbo].[HotNotes]
(
[Number] [int] NOT NULL,
[HotNote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HotNotes] ADD CONSTRAINT [PK_HotNotes] PRIMARY KEY CLUSTERED ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Note that appears in the upper right corner of the workform.  Only one note allowed per account and may be updated by user.', 'SCHEMA', N'dbo', 'TABLE', N'HotNotes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free form text note', 'SCHEMA', N'dbo', 'TABLE', N'HotNotes', 'COLUMN', N'HotNote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account Filenumber ID', 'SCHEMA', N'dbo', 'TABLE', N'HotNotes', 'COLUMN', N'Number'
GO
