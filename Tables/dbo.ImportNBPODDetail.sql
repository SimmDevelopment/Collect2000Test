CREATE TABLE [dbo].[ImportNBPODDetail]
(
[Number] [int] NOT NULL,
[InvoiceNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceDate] [datetime] NULL,
[InvoiceDetail] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceAmount] [money] NOT NULL,
[PaidAmt] [money] NULL,
[CurrentAmt] [money] NULL,
[CustBranch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
