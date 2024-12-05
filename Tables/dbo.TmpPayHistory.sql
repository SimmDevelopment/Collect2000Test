CREATE TABLE [dbo].[TmpPayHistory]
(
[Number] [int] NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[datepaid] [datetime] NULL,
[BatchType] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalPaid] [money] NULL,
[Fee1] [money] NULL,
[Fee2] [money] NULL,
[Fee3] [money] NULL,
[Fee4] [money] NULL,
[Fee5] [money] NULL,
[Fee6] [money] NULL,
[Fee7] [money] NULL,
[Fee8] [money] NULL,
[Fee9] [money] NULL,
[Fee10] [money] NULL
) ON [PRIMARY]
GO
