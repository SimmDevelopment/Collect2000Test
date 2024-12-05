CREATE TABLE [dbo].[Services]
(
[ServiceId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [bit] NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ftp] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Usercode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contact] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MinBalance] [money] NULL,
[UpdateAccounts] [bit] NULL,
[ServiceBatch] [int] NULL,
[TransformationSchema] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequestObject] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllowDays] [int] NULL,
[DataSchema] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ManifestID] [uniqueidentifier] NULL,
[ImportDefinition] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImportDataSetSchema] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImportMappingDefinition] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImportFileType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Template] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vendor] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Product] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PDTType] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services] ADD CONSTRAINT [PK_Services] PRIMARY KEY CLUSTERED ([ServiceId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'Services', 'COLUMN', N'ServiceId'
GO
