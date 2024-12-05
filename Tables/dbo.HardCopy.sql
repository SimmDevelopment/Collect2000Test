CREATE TABLE [dbo].[HardCopy]
(
[number] [int] NOT NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hardCopyType] [smallint] NULL,
[hardCopyData] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImageID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [hardcopy1] ON [dbo].[HardCopy] ([number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Text table used to retain debtor credit report', 'SCHEMA', N'dbo', 'TABLE', N'HardCopy', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Text field containing credit report', 'SCHEMA', N'dbo', 'TABLE', N'HardCopy', 'COLUMN', N'hardCopyData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ImageID of encrypted data relating to images table', 'SCHEMA', N'dbo', 'TABLE', N'HardCopy', 'COLUMN', N'ImageID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account Filenumber ID', 'SCHEMA', N'dbo', 'TABLE', N'HardCopy', 'COLUMN', N'number'
GO
