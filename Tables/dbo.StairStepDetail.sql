CREATE TABLE [dbo].[StairStepDetail]
(
[StairStepHeaderID] [int] NOT NULL,
[FiscalDate] [date] NOT NULL,
[TotalCollectedAmount] [decimal] (19, 4) NOT NULL,
[TotalFeeAmount] [decimal] (19, 4) NOT NULL,
[InvoiceableCollectedAmount] [decimal] (19, 4) NOT NULL,
[InvoiceableFeeAmount] [decimal] (19, 4) NOT NULL,
[AdjustmentAmount] [decimal] (19, 4) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StairStepDetail] ADD CONSTRAINT [PK_StairStepDetail] PRIMARY KEY CLUSTERED ([StairStepHeaderID], [FiscalDate]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monthly Fiscal Data for Stair Step Schema.  Includes data ALL accounts placed within the fiscal month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepDetail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of Adjustments during the month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepDetail', 'COLUMN', N'AdjustmentAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fiscal Month Transactions were made.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepDetail', 'COLUMN', N'FiscalDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of Invoiceable (paid1 - 10) amount during the month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepDetail', 'COLUMN', N'InvoiceableCollectedAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of Invoiceable (fee1 - 10) amount during the month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepDetail', 'COLUMN', N'InvoiceableFeeAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign Key to dbo.StairStepHeader.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepDetail', 'COLUMN', N'StairStepHeaderID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of (paid1 - 10) amount during the month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepDetail', 'COLUMN', N'TotalCollectedAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of (fee1 - 10) amount during the month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepDetail', 'COLUMN', N'TotalFeeAmount'
GO
