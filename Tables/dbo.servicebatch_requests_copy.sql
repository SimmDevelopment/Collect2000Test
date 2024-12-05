CREATE TABLE [dbo].[servicebatch_requests_copy]
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
[xmlRequest] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
