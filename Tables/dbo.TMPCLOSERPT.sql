CREATE TABLE [dbo].[TMPCLOSERPT]
(
[Number] [int] NULL,
[SortData] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTHER] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RECEIVED] [datetime] NULL,
[LastPaid] [datetime] NULL,
[status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Original] [money] NULL,
[CURRENT0] [money] NULL,
[DESK] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESKNAME] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customername] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusDesc] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[company] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
