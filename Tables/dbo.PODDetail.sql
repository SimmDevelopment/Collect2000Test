CREATE TABLE [dbo].[PODDetail]
(
[Number] [int] NOT NULL,
[InvoiceNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceDate] [datetime] NULL,
[InvoiceDetail] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceAmount] [money] NOT NULL,
[Uid] [int] NOT NULL IDENTITY(1, 1),
[PaidAmt] [money] NULL,
[CurrentAmt] [money] NULL,
[CustBranch] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PODDetail] ADD CONSTRAINT [PK_PODDetail] PRIMARY KEY NONCLUSTERED ([Uid]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PODDetail] ON [dbo].[PODDetail] ([InvoiceNumber]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PODDetail_1] ON [dbo].[PODDetail] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIDIndex] ON [dbo].[PODDetail] ([Uid]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
