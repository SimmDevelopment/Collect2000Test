CREATE TABLE [dbo].[dialerinstance_backup]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DialerType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Active] [bit] NOT NULL,
[DataSource] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InitialCatalog] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserId] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataPath] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HistoryTable] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DialerServer] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DialerPort] [int] NOT NULL,
[TransferCRC] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HistoryLastReadDate] [datetime] NULL,
[HistoryLastReadId] [int] NULL,
[DoNotCallFileInfo] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RFU] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
