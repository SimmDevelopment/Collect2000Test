CREATE TABLE [dbo].[StairStepReductionHeader]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PlacementDate] [date] NOT NULL,
[PlacementNumber] [int] NOT NULL,
[DollarsPlacedAmount] [decimal] (19, 4) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StairStepReductionHeader] ADD CONSTRAINT [PK_StairStepReductionHeader] PRIMARY KEY CLUSTERED ([Customer], [PlacementDate]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Level Reduction Data for Stair Step Schema.  Includes ONLY data for accounts in a "reduce stats" status within the fiscal month.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionHeader', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer which placed accounts.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionHeader', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of "master.Original" of accounts placed.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionHeader', 'COLUMN', N'DollarsPlacedAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Primary Key of table.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionHeader', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month accounts were placed.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionHeader', 'COLUMN', N'PlacementDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numbe of accounts placed.', 'SCHEMA', N'dbo', 'TABLE', N'StairStepReductionHeader', 'COLUMN', N'PlacementNumber'
GO
