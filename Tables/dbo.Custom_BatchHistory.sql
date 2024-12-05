CREATE TABLE [dbo].[Custom_BatchHistory]
(
[BatchHistoryId] [int] NOT NULL IDENTITY(1, 1),
[CustomerReferenceId] [int] NULL,
[BatchTypeId] [int] NULL,
[StartedDateTime] [datetime] NULL,
[EndedDateTime] [datetime] NULL,
[RawSource] [image] NULL,
[RawSourceFileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MappingXml] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MappingOutput] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MappingOutputWithDisposition] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceXml] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RawSourceZip] [image] NULL,
[MappingOutputZip] [image] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_BatchHistory] ADD CONSTRAINT [PK_Custom_BatchHistory] PRIMARY KEY CLUSTERED ([BatchHistoryId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_BatchHistory] ADD CONSTRAINT [FK_Custom_BatchHistory_Custom_BatchType] FOREIGN KEY ([BatchTypeId]) REFERENCES [dbo].[Custom_BatchType] ([BatchTypeId])
GO
ALTER TABLE [dbo].[Custom_BatchHistory] ADD CONSTRAINT [FK_Custom_BatchHistory_Custom_CustomerReference] FOREIGN KEY ([CustomerReferenceId]) REFERENCES [dbo].[Custom_CustomerReference] ([CustomerReferenceId]) ON DELETE CASCADE
GO
