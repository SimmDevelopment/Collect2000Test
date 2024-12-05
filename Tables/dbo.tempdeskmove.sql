CREATE TABLE [dbo].[tempdeskmove]
(
[number] [int] NULL,
[desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[oldbranch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[newbranch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[user0] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comment] [varchar] (800) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[olddesk] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
