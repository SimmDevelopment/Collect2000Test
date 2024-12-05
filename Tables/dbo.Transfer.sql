CREATE TABLE [dbo].[Transfer]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransferTypeID] [tinyint] NULL,
[Username] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Host] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Port] [int] NULL,
[Passive] [bit] NULL,
[Explicit] [bit] NULL,
[PickupMode] [bit] NULL,
[Overwrite] [bit] NULL,
[RegexDownloadFileExpression] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RemoteDirectoryLocation] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UploadFileExpression] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocalDirectoryLocation] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RenameRemoteFileOnDownload] [bit] NULL,
[RenamedLocalFileExpression] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Transfer] ADD CONSTRAINT [PK_Transfer] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Transfer] ADD CONSTRAINT [FK_Transfer_TransferType] FOREIGN KEY ([TransferTypeID]) REFERENCES [dbo].[TransferType] ([ID])
GO
