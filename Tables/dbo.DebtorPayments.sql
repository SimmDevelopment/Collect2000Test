CREATE TABLE [dbo].[DebtorPayments]
(
[Number] [int] NOT NULL,
[qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Original] [money] NULL,
[Description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalPaid] [money] NULL,
[TotalAdjustments] [money] NULL,
[CustomerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DebtorPayments] ADD CONSTRAINT [PK_DebtorPayments] PRIMARY KEY NONCLUSTERED ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_DebtorPayments] ON [dbo].[DebtorPayments] ([Customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DebtorPayments_1] ON [dbo].[DebtorPayments] ([qlevel]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
