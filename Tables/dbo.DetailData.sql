CREATE TABLE [dbo].[DetailData]
(
[Number] [int] NULL,
[DetailCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DetailDESCRIPTION] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DetailDate] [datetime] NULL,
[DetailAmount] [money] NULL
) ON [PRIMARY]
GO
