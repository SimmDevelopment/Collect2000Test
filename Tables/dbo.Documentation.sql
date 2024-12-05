CREATE TABLE [dbo].[Documentation]
(
[UID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__Documentati__UID__2879A833] DEFAULT (newid()),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Documenta__Creat__296DCC6C] DEFAULT (getdate()),
[FileName] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileSize] [bigint] NOT NULL,
[SHA1Hash] [binary] (20) NOT NULL,
[Extension] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Image] [image] NOT NULL,
[Thumbnail] [image] NULL,
[Location] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Documentation] ADD CONSTRAINT [pk_Documentation] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Documentation] ON [dbo].[Documentation] ([SHA1Hash], [FileSize], [FileName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table used to retain scanned images, letter images and other documents that may be  attched to the account.', 'SCHEMA', N'dbo', 'TABLE', N'Documentation', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp created', 'SCHEMA', N'dbo', 'TABLE', N'Documentation', 'COLUMN', N'CreatedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'File Extension', 'SCHEMA', N'dbo', 'TABLE', N'Documentation', 'COLUMN', N'Extension'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Filename', 'SCHEMA', N'dbo', 'TABLE', N'Documentation', 'COLUMN', N'FileName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Size in Bytes', 'SCHEMA', N'dbo', 'TABLE', N'Documentation', 'COLUMN', N'FileSize'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Binary Document File Image', 'SCHEMA', N'dbo', 'TABLE', N'Documentation', 'COLUMN', N'Image'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Path', 'SCHEMA', N'dbo', 'TABLE', N'Documentation', 'COLUMN', N'Location'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Computed Hash Key ', 'SCHEMA', N'dbo', 'TABLE', N'Documentation', 'COLUMN', N'SHA1Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Thumbnail Image', 'SCHEMA', N'dbo', 'TABLE', N'Documentation', 'COLUMN', N'Thumbnail'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Documentation', 'COLUMN', N'UID'
GO
