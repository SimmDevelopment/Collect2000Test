CREATE TABLE [dbo].[LionLog]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Date] [datetime] NOT NULL,
[Thread] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Level] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Logger] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Message] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Exception] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
