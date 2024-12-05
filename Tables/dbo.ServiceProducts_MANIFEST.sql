CREATE TABLE [dbo].[ServiceProducts_MANIFEST]
(
[ProductID] [uniqueidentifier] NOT NULL,
[ManifestID] [uniqueidentifier] NOT NULL,
[Name] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProfileID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceProducts_MANIFEST] ADD CONSTRAINT [PK_ServiceProducts_MANIFEST] PRIMARY KEY CLUSTERED ([ProductID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServiceProducts_MANIFEST_ManifestID] ON [dbo].[ServiceProducts_MANIFEST] ([ManifestID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceProducts_MANIFEST] ADD CONSTRAINT [FK_ServiceProducts_MANIFEST_Services_MANIFEST] FOREIGN KEY ([ManifestID]) REFERENCES [dbo].[Services_MANIFEST] ([ManifestID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
