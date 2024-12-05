CREATE TABLE [dbo].[AIM_PortfolioInvestor]
(
[PortfolioInvestorId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioId] [int] NULL,
[InvestorId] [int] NULL,
[CommissionableAmount] [money] NULL,
[NonCommissionableAmount] [money] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'amount that is commissionable for the investor', 'SCHEMA', N'dbo', 'TABLE', N'AIM_PortfolioInvestor', 'COLUMN', N'CommissionableAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'associated investor id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_PortfolioInvestor', 'COLUMN', N'InvestorId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'amount that is non-commissionable for the investor', 'SCHEMA', N'dbo', 'TABLE', N'AIM_PortfolioInvestor', 'COLUMN', N'NonCommissionableAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'associated portfolio for this investor', 'SCHEMA', N'dbo', 'TABLE', N'AIM_PortfolioInvestor', 'COLUMN', N'PortfolioId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_PortfolioInvestor', 'COLUMN', N'PortfolioInvestorId'
GO
