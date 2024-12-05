CREATE TABLE [dbo].[RmsmaintLog]
(
[Seq] [int] NULL,
[account] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Transcode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WholeData] [char] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileName] [char] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [char] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
