CREATE TABLE [dbo].[zgenesisstatus]
(
[Vendor] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACCOUNT] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientActNum] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[balance] [money] NULL
) ON [PRIMARY]
GO
