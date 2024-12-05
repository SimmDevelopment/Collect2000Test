CREATE TABLE [dbo].[ImportPODs]
(
[ImportAcctID] [int] NOT NULL,
[InvoiceNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InvoiceDate] [datetime] NULL,
[InvoiceDetail] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceAmount] [money] NOT NULL,
[Uid] [int] NOT NULL IDENTITY(1, 1),
[CustBranch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
