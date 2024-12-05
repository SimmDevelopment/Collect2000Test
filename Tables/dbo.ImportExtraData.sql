CREATE TABLE [dbo].[ImportExtraData]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[BatchID] [int] NOT NULL,
[ImportAcctID] [int] NOT NULL,
[ExtraCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Line1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line3] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line4] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Line5] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImportExtraData] ADD CONSTRAINT [PK_ImportExtraData] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table used by Import Excel', 'SCHEMA', N'dbo', 'TABLE', N'ImportExtraData', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Batch Identity of Import', 'SCHEMA', N'dbo', 'TABLE', N'ImportExtraData', 'COLUMN', N'BatchID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Key code and display code for ExtraData', 'SCHEMA', N'dbo', 'TABLE', N'ImportExtraData', 'COLUMN', N'ExtraCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportExtraData', 'COLUMN', N'ImportAcctID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 1', 'SCHEMA', N'dbo', 'TABLE', N'ImportExtraData', 'COLUMN', N'Line1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 2', 'SCHEMA', N'dbo', 'TABLE', N'ImportExtraData', 'COLUMN', N'Line2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 3', 'SCHEMA', N'dbo', 'TABLE', N'ImportExtraData', 'COLUMN', N'Line3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line 4', 'SCHEMA', N'dbo', 'TABLE', N'ImportExtraData', 'COLUMN', N'Line4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data line5', 'SCHEMA', N'dbo', 'TABLE', N'ImportExtraData', 'COLUMN', N'Line5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'ImportExtraData', 'COLUMN', N'UID'
GO
