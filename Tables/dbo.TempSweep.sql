CREATE TABLE [dbo].[TempSweep]
(
[AcctID] [int] NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Original] [money] NULL,
[Paid] [money] NULL,
[Current0] [money] NULL,
[Desk] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
