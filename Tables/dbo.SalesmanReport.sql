CREATE TABLE [dbo].[SalesmanReport]
(
[SalesCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAME] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COLLECTIONS] [money] NULL,
[FEES] [money] NULL
) ON [PRIMARY]
GO
