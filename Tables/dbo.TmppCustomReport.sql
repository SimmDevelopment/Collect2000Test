CREATE TABLE [dbo].[TmppCustomReport]
(
[Number] [int] NULL,
[QDATE] [char] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DONE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NAME] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[received] [datetime] NULL,
[current0] [money] NULL,
[Original] [money] NULL,
[status] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
