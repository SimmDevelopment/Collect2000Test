CREATE TABLE [dbo].[ServiceRequest_PRESETS]
(
[PresetID] [uniqueidentifier] NOT NULL,
[ManifestID] [uniqueidentifier] NOT NULL,
[Recurring] [bit] NOT NULL,
[IncludeCodebtors] [bit] NOT NULL,
[DateCreated] [datetime] NOT NULL,
[imgPreset] [image] NOT NULL,
[xmlPreset] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceRequest_PRESETS] ADD CONSTRAINT [PK_ServiceRequest_PRESETS] PRIMARY KEY CLUSTERED ([PresetID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServiceRequest_PRESETS] ON [dbo].[ServiceRequest_PRESETS] ([ManifestID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
