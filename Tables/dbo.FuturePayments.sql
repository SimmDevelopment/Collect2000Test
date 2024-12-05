CREATE TABLE [dbo].[FuturePayments]
(
[Id] [uniqueidentifier] NOT NULL,
[SettlementOfferId] [uniqueidentifier] NOT NULL,
[SuggestedPaymentDate] [datetime] NOT NULL,
[MinDate] [datetime] NOT NULL,
[MaxDate] [datetime] NOT NULL,
[SuggestedPaymentAmount] [money] NOT NULL,
[MinPaymentAmount] [money] NOT NULL,
[MaxPaymentAmount] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FuturePayments] ADD CONSTRAINT [PK_FuturePayments] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FuturePayments] ADD CONSTRAINT [FK_FuturePayments_SettlementOffers] FOREIGN KEY ([SettlementOfferId]) REFERENCES [dbo].[SettlementOffers] ([Id]) ON DELETE CASCADE
GO
