CREATE TABLE [dbo].[Receiver_FileType]
(
[FileTypeId] [int] NOT NULL,
[Name] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_FileType] ADD CONSTRAINT [PK_Receiver_FileType] PRIMARY KEY CLUSTERED ([FileTypeId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_FileType', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_FileType', 'COLUMN', N'FileTypeId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_FileType', 'COLUMN', N'Name'
GO
