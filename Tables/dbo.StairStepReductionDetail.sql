CREATE TABLE [dbo].[StairStepReductionDetail]
(
[StairStepReductionHeaderID] [int] NOT NULL,
[FiscalDate] [date] NOT NULL,
[TotalCollectedAmount] [decimal] (19, 4) NOT NULL,
[TotalFeeAmount] [decimal] (19, 4) NOT NULL,
[InvoiceableCollectedAmount] [decimal] (19, 4) NOT NULL,
[InvoiceableFeeAmount] [decimal] (19, 4) NOT NULL,
[AdjustmentAmount] [decimal] (19, 4) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StairStepReductionDetail] ADD CONSTRAINT [PK_StairStepReductionDetail] PRIMARY KEY CLUSTERED ([StairStepReductionHeaderID], [FiscalDate]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monthly Fiscal Reduction Data for Stair Step Schema.  Includes ONLY data for accounts in a "reduce stats" status within the fiscal month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionDetail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of Adjustments during the month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionDetail', 'COLUMN', N'AdjustmentAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fiscal Month Transactions were made.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionDetail', 'COLUMN', N'FiscalDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of Invoiceable (paid1 - 10) amount during the month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionDetail', 'COLUMN', N'InvoiceableCollectedAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of Invoiceable (fee1 - 10) amount during the month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionDetail', 'COLUMN', N'InvoiceableFeeAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign Key to dbo.StairStepReductionHeader.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionDetail', 'COLUMN', N'StairStepReductionHeaderID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of (paid1 - 10) amount during the month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionDetail', 'COLUMN', N'TotalCollectedAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of (fee1 - 10) amount during the month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionDetail', 'COLUMN', N'TotalFeeAmount'
GO
