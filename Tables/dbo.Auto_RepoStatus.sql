CREATE TABLE [dbo].[Auto_RepoStatus]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[statustype] [int] NULL,
[Status] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
