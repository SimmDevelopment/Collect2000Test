CREATE TABLE [dbo].[StairStep_Temp_Transactions]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PlacementMonth] [datetime] NOT NULL,
[TransactionMonth] [datetime] NOT NULL,
[Transactions] [bigint] NULL,
[Paid] [money] NULL,
[Fee] [money] NULL,
[PrincipalPaid] [money] NULL,
[PrincipalFee] [money] NULL,
[InvoicablePaid] [money] NULL,
[InvoicableFee] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StairStep_Temp_Transactions] ADD CONSTRAINT [PK_SS_Transactions] PRIMARY KEY CLUSTERED ([Customer], [PlacementMonth], [TransactionMonth]) ON [PRIMARY]
GO
