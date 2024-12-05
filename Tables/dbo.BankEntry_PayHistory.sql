CREATE TABLE [dbo].[BankEntry_PayHistory]
(
[BankEntryId] [int] NOT NULL,
[PayhistoryId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BankEntry_PayHistory] ADD CONSTRAINT [PK_BankEntry_PayHistory] PRIMARY KEY CLUSTERED ([BankEntryId], [PayhistoryId]) ON [PRIMARY]
GO
