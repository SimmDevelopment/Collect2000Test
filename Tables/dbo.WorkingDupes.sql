CREATE TABLE [dbo].[WorkingDupes]
(
[Number1] [int] NULL,
[link1] [int] NULL,
[desk1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[received1] [datetime] NULL,
[status1] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer1] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN1] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Qlevel1] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number2] [int] NULL,
[link2] [int] NULL,
[desk2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[received2] [datetime] NULL,
[status2] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer2] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN2] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Qlevel2] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MatchFlag] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MatchMsg] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
