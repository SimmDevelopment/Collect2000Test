CREATE TABLE [dbo].[cbr_PortfolioType_AccountType]
(
[portfolioType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[accountType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_PortfolioType_AccountType] ADD CONSTRAINT [PK_cbr_PortfolioType_AccountType] PRIMARY KEY CLUSTERED ([portfolioType], [accountType]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'cbr_PortfolioType_AccountType', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'cbr_PortfolioType_AccountType', 'COLUMN', N'accountType'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'cbr_PortfolioType_AccountType', 'COLUMN', N'portfolioType'
GO
