CREATE TABLE [dbo].[ShermanBalanceHolding]
(
[Number] [int] NULL,
[Balance1] [money] NULL,
[Balance2] [money] NULL,
[Balance3] [money] NULL,
[Balance4] [money] NULL,
[UID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ShermanBalanceHolding] ADD CONSTRAINT [PK_ShermanBalanceHolding] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
