CREATE TABLE [dbo].[Exchange_VersionHistory]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Altered] [datetime] NULL,
[UserID] [int] NULL,
[ClientId] [int] NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClientDef] [image] NULL,
[Comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Exchange_VersionHistory] ADD CONSTRAINT [PK_Exchange_VersionHistory] PRIMARY KEY CLUSTERED ([Id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction history that tracks updates to Exchange Clients.  Exhange is a add-on tool that allows Latitude customers to create and maintain their own custom interfaces for using an intuitive, drag and drop application.  This program enables users to create a custom library for all new business, maintenance; financial, audit and customer recall file transfers', 'SCHEMA', N'dbo', 'TABLE', N'Exchange_VersionHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'Exchange_VersionHistory', 'COLUMN', N'Altered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Update Remarks', 'SCHEMA', N'dbo', 'TABLE', N'Exchange_VersionHistory', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Exchange_VersionHistory', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Identity Key for respective User', 'SCHEMA', N'dbo', 'TABLE', N'Exchange_VersionHistory', 'COLUMN', N'UserID'
GO
