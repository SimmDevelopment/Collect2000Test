CREATE TABLE [dbo].[ccj_backup_ExchangeAuto]
(
[ID] [uniqueidentifier] NOT NULL,
[Name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FolderPath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileNameRegex] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutputFolderPath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorEmail] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StopAllOnError] [bit] NULL,
[EmailOnSuccess] [bit] NULL,
[ImportConfigXml] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OwnerInterfacePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AutoProcessAllowed] [bit] NULL,
[TransferType] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Server] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Username] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Port] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProtectionID] [int] NULL,
[TransferID] [int] NULL
) ON [PRIMARY]
GO
