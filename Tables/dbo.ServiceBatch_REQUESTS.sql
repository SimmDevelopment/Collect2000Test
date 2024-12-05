CREATE TABLE [dbo].[ServiceBatch_REQUESTS]
(
[BatchID] [uniqueidentifier] NOT NULL,
[ServiceID] [int] NOT NULL,
[ManifestID] [uniqueidentifier] NOT NULL,
[ProfileID] [uniqueidentifier] NOT NULL,
[PresetID] [uniqueidentifier] NOT NULL,
[DateRequested] [datetime] NOT NULL,
[DateSent] [datetime] NULL,
[DateLoaded] [datetime] NULL,
[DateProcessed] [datetime] NULL,
[RequestedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequestedProgram] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[imgRequest] [image] NOT NULL,
[xmlRequest] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PackageID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceBatch_REQUESTS] ADD CONSTRAINT [PK_ServiceBatch_REQUESTS] PRIMARY KEY CLUSTERED ([BatchID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServiceBatch_REQUESTS] ON [dbo].[ServiceBatch_REQUESTS] ([PresetID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServiceBatch_REQUESTS_ProfileID] ON [dbo].[ServiceBatch_REQUESTS] ([ProfileID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServiceBatch_REQUESTS] ADD CONSTRAINT [FK_ServiceBatch_REQUESTS_Fusion_Packages] FOREIGN KEY ([PackageID]) REFERENCES [dbo].[Fusion_Packages] ([ID])
GO
ALTER TABLE [dbo].[ServiceBatch_REQUESTS] ADD CONSTRAINT [FK_ServiceBatch_REQUESTS_ServiceRequest_PRESETS] FOREIGN KEY ([PresetID]) REFERENCES [dbo].[ServiceRequest_PRESETS] ([PresetID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ServiceBatch_REQUESTS] ADD CONSTRAINT [FK_ServiceBatch_REQUESTS_Services] FOREIGN KEY ([ServiceID]) REFERENCES [dbo].[Services] ([ServiceId])
GO
