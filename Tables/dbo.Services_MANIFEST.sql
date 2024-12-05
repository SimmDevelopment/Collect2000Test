CREATE TABLE [dbo].[Services_MANIFEST]
(
[ManifestID] [uniqueidentifier] NOT NULL,
[Name] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [bit] NULL,
[Publish] [bit] NULL,
[Profile] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XmlResponseEngine] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XPathMatch] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XPathMatchRequestID] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XPathNoMatch] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[XPathNoMatchRequestID] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_MANIFEST] ADD CONSTRAINT [PK_Services_MANIFEST] PRIMARY KEY CLUSTERED ([ManifestID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Services_MANIFEST_Profile] ON [dbo].[Services_MANIFEST] ([Profile]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
