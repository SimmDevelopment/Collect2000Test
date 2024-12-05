CREATE TABLE [dbo].[CustomerPayments]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TotalPaidSum] [money] NOT NULL,
[Reversals] [money] NOT NULL,
[DatePaidMonth] [int] NULL,
[DatePaidYear] [int] NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_CustomerPayments] ON [dbo].[CustomerPayments] ([Customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CustomerPayments_1] ON [dbo].[CustomerPayments] ([Customer], [DatePaidMonth], [DatePaidYear]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
