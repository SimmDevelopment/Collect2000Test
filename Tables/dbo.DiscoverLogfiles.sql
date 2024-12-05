CREATE TABLE [dbo].[DiscoverLogfiles]
(
[LogDate] [datetime] NULL,
[LogTranslatorName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seq] [int] NOT NULL IDENTITY(1, 1),
[account] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Transcode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WholeData] [char] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [char] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [char] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
