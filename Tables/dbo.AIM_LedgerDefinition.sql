CREATE TABLE [dbo].[AIM_LedgerDefinition]
(
[LedgerDefinitionId] [int] NOT NULL IDENTITY(1, 1),
[LedgerTypeId] [int] NULL,
[RecoursePeriodDays] [int] NULL,
[Condition] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CalculationTypeId] [int] NULL,
[CalculationAmount] [float] NULL,
[PortfolioId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_LedgerDefinition] ADD CONSTRAINT [PK_AIM_LedgerDefinition] PRIMARY KEY CLUSTERED ([LedgerDefinitionId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_LedgerDefinition] ADD CONSTRAINT [FK_AIM_LedgerDefinition_AIM_CalculationType] FOREIGN KEY ([CalculationTypeId]) REFERENCES [dbo].[AIM_CalculationType] ([CalculationTypeId])
GO
ALTER TABLE [dbo].[AIM_LedgerDefinition] ADD CONSTRAINT [FK_AIM_LedgerDefinition_AIM_LedgerType] FOREIGN KEY ([LedgerTypeId]) REFERENCES [dbo].[AIM_LedgerType] ([LedgerTypeId])
GO
ALTER TABLE [dbo].[AIM_LedgerDefinition] ADD CONSTRAINT [FK_AIM_LedgerDefinition_AIM_Portfolio] FOREIGN KEY ([PortfolioId]) REFERENCES [dbo].[AIM_Portfolio] ([PortfolioId]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'the amount associated with the calculation', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerDefinition', 'COLUMN', N'CalculationAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'associated calculation type', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerDefinition', 'COLUMN', N'CalculationTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Condition of the ledger entry', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerDefinition', 'COLUMN', N'Condition'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerDefinition', 'COLUMN', N'LedgerDefinitionId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of ledger entry', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerDefinition', 'COLUMN', N'LedgerTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerDefinition', 'COLUMN', N'PortfolioId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'days allowed for recourse', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerDefinition', 'COLUMN', N'RecoursePeriodDays'
GO
