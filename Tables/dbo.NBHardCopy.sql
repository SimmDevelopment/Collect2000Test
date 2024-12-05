CREATE TABLE [dbo].[NBHardCopy]
(
[number] [int] NOT NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hardCopyType] [smallint] NULL,
[hardCopyData] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data from HardCopy', 'SCHEMA', N'dbo', 'TABLE', N'NBHardCopy', 'COLUMN', N'hardCopyData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of HardCopy', 'SCHEMA', N'dbo', 'TABLE', N'NBHardCopy', 'COLUMN', N'hardCopyType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'NBHardCopy', 'COLUMN', N'number'
GO
