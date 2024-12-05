CREATE TABLE [dbo].[SysInv1]
(
[SORTDATA] [char] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NUMBER] [int] NULL,
[NAME] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTHER] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNT] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RECEIVED] [datetime] NULL,
[LASTPAID] [datetime] NULL,
[STATUS] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORIGINAL] [money] NULL,
[CURRENT0] [money] NULL,
[CUSTOMER] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESK] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESKNAME] [char] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMERNAME] [char] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMPANY] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
