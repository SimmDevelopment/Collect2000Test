CREATE TABLE [dbo].[AIM_Portfolio]
(
[PortfolioId] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContractDate] [datetime] NULL,
[Amount] [money] NULL,
[BuyerGroupId] [int] NULL,
[SellerGroupId] [int] NULL,
[InvestorGroupId] [int] NULL,
[PortfolioTypeId] [int] NULL,
[OriginalFaceValue] [money] NULL,
[CostPerFaceDollar] [float] NULL,
[CultureCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__AIM_Portf__Cultu__13B85981] DEFAULT ('en-US'),
[GeneralLedgerID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellerLotNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Portfolio] ADD CONSTRAINT [PK_AIM_Portfolio] PRIMARY KEY CLUSTERED ([PortfolioId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Portfolio] ADD CONSTRAINT [FK_AIM_Portfolio_AIM_Group] FOREIGN KEY ([InvestorGroupId]) REFERENCES [dbo].[AIM_Group] ([GroupId])
GO
ALTER TABLE [dbo].[AIM_Portfolio] ADD CONSTRAINT [FK_AIM_Portfolio_AIM_PortfolioType] FOREIGN KEY ([PortfolioTypeId]) REFERENCES [dbo].[AIM_PortfolioType] ([PortfolioTypeId])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of the purchase/sale transaction', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Associated group that bought the portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'BuyerGroupId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined code of the portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date the portfolio was bought or sold', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'ContractDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Strike price', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'CostPerFaceDollar'
GO
EXEC sp_addextendedproperty N'MS_Description', N'type of monetary units for the portfolio (en-US,en-C)', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'CultureCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of the portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined code of the portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'GeneralLedgerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Associated group that invested in the portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'InvestorGroupId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of Original of the accounts', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'OriginalFaceValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'PortfolioId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of portfolio (PURCHASE,SALE,SAMPLE)', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'PortfolioTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Associated group that sold the portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'SellerGroupId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined code of the portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Portfolio', 'COLUMN', N'SellerLotNumber'
GO
