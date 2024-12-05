CREATE TABLE [dbo].[AIM_TempPurchaseAccounts]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_TempPurchaseAccounts] ADD CONSTRAINT [PK_AIM_TempPurchaseAccounts] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
