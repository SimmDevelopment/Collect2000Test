CREATE TABLE [dbo].[Receiver_DebtorReference]
(
[DebtorReferenceId] [int] NOT NULL IDENTITY(1, 1),
[SenderDebtorId] [int] NULL,
[ReceiverDebtorId] [int] NULL,
[ClientId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_DebtorReference] ADD CONSTRAINT [PK_Receiver_DebtorReference] PRIMARY KEY CLUSTERED ([DebtorReferenceId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
