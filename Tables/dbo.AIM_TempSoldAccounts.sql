CREATE TABLE [dbo].[AIM_TempSoldAccounts]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_TempSoldAccounts] ADD CONSTRAINT [PK_AIM_TempSoldAccounts] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
