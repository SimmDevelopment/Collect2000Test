CREATE TABLE [dbo].[DocumergeArchive]
(
[DocumergeArchiveID] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NOT NULL,
[DocImage] [image] NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF_DocumergeArchive_Created] DEFAULT (getdate()),
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumergeArchive] ADD CONSTRAINT [PK_DocumergeArchive] PRIMARY KEY CLUSTERED ([DocumergeArchiveID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
