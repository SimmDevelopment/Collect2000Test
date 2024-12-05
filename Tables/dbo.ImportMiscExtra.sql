CREATE TABLE [dbo].[ImportMiscExtra]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[BatchID] [int] NOT NULL,
[ImportAcctID] [int] NOT NULL,
[Title] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TheData] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table used by Import Excel', 'SCHEMA', N'dbo', 'TABLE', N'ImportMiscExtra', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Batch Identity of Import', 'SCHEMA', N'dbo', 'TABLE', N'ImportMiscExtra', 'COLUMN', N'BatchID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportMiscExtra', 'COLUMN', N'ImportAcctID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data associated with Title and account', 'SCHEMA', N'dbo', 'TABLE', N'ImportMiscExtra', 'COLUMN', N'TheData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descriptive Title of Data or Code, Search Key, Display name in Latitude', 'SCHEMA', N'dbo', 'TABLE', N'ImportMiscExtra', 'COLUMN', N'Title'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'ImportMiscExtra', 'COLUMN', N'UID'
GO
