CREATE TABLE [dbo].[Custom_LatitudeDocumentAttacher]
(
[AttachedFiles_ArchiveDirectory] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorLog_Directory] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source_Directory] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContextExpLocator] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CopyDirectoryStructure] [bit] NULL,
[ContainsCategoryExpLocator] [bit] NULL,
[SearchSubFolders] [bit] NULL,
[LocateBy] [int] NULL,
[MoveAttachedDocuments] [bit] NULL,
[GenerateThumbnail] [bit] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Configuration Settings for Latitude Document Attacher program.', 'SCHEMA', N'dbo', 'TABLE', N'Custom_LatitudeDocumentAttacher', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Directory to move attached files to', 'SCHEMA', N'dbo', 'TABLE', N'Custom_LatitudeDocumentAttacher', 'COLUMN', N'AttachedFiles_ArchiveDirectory'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Setting which determines regular expression also captures the category to be used when attaching the file', 'SCHEMA', N'dbo', 'TABLE', N'Custom_LatitudeDocumentAttacher', 'COLUMN', N'ContainsCategoryExpLocator'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Regular expression used to evaluate files as candidate attachments', 'SCHEMA', N'dbo', 'TABLE', N'Custom_LatitudeDocumentAttacher', 'COLUMN', N'ContextExpLocator'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Setting which determines if the directory structure from which candidate attachments are located is replicated', 'SCHEMA', N'dbo', 'TABLE', N'Custom_LatitudeDocumentAttacher', 'COLUMN', N'CopyDirectoryStructure'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Directory to write error logs to', 'SCHEMA', N'dbo', 'TABLE', N'Custom_LatitudeDocumentAttacher', 'COLUMN', N'ErrorLog_Directory'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Setting which determines if thumbnail is generated for the attached file', 'SCHEMA', N'dbo', 'TABLE', N'Custom_LatitudeDocumentAttacher', 'COLUMN', N'GenerateThumbnail'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Setting which determines how the master record for which the attachment is being attached to is located (number, account, debtorid, requestid)', 'SCHEMA', N'dbo', 'TABLE', N'Custom_LatitudeDocumentAttacher', 'COLUMN', N'LocateBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Setting which determines if the attached files are moved to the archive folder', 'SCHEMA', N'dbo', 'TABLE', N'Custom_LatitudeDocumentAttacher', 'COLUMN', N'MoveAttachedDocuments'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Setting which determines if sub folders of the source folder are evaluated for attachment candidates', 'SCHEMA', N'dbo', 'TABLE', N'Custom_LatitudeDocumentAttacher', 'COLUMN', N'SearchSubFolders'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Directory in which source files to attach are located', 'SCHEMA', N'dbo', 'TABLE', N'Custom_LatitudeDocumentAttacher', 'COLUMN', N'Source_Directory'
GO
