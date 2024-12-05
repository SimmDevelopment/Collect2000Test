CREATE TABLE [dbo].[TimeClock]
(
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginDate] [datetime] NULL,
[LoginTime] [datetime] NULL,
[TimeOff] [datetime] NULL,
[Totalseconds] [int] NULL
) ON [PRIMARY]
GO
