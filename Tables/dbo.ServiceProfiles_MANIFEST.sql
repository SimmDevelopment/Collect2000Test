CREATE TABLE [dbo].[ServiceProfiles_MANIFEST]
(
[ProfileID] [uniqueidentifier] NOT NULL,
[ManifestID] [uniqueidentifier] NOT NULL,
[Name] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL,
[IsDataWarehoused] [bit] NULL,
[MaxRecords] [int] NULL,
[OutPath] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutFilenameExpression] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutFilenameFormat] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InPath] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InFilenameExpression] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InFilenameFormat] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CorrespondingFilenameReplace] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArchivePath] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExceptionPath] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ftpEnabled] [bit] NULL,
[ftpServer] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ftpUser] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ftpPassword] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ftpOutPath] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessResponse] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceProfiles_MANIFEST] ADD CONSTRAINT [PK_ServiceProfiles_MANIFEST] PRIMARY KEY CLUSTERED ([ProfileID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServiceProfiles_MANIFEST_ManifestID] ON [dbo].[ServiceProfiles_MANIFEST] ([ManifestID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceProfiles_MANIFEST] ADD CONSTRAINT [FK_ServiceProfiles_MANIFEST_Services_MANIFEST] FOREIGN KEY ([ManifestID]) REFERENCES [dbo].[Services_MANIFEST] ([ManifestID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
