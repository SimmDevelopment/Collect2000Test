CREATE TABLE [dbo].[Attunely_Attributes]
(
[Id] [uniqueidentifier] NOT NULL,
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FieldName_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Attributes] ADD CONSTRAINT [PK_Attunely_Attributes] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
