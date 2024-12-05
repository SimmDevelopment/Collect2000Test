CREATE TABLE [dbo].[StairStep_Temp_Adjustments]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PlacementMonth] [datetime] NOT NULL,
[AdjustmentTransactions] [bigint] NULL,
[AmountAdjusted] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StairStep_Temp_Adjustments] ADD CONSTRAINT [PK_SS_Adjustments] PRIMARY KEY CLUSTERED ([Customer], [PlacementMonth]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_StairStep_Temp_Adjustments_PlacementMonth] ON [dbo].[StairStep_Temp_Adjustments] ([PlacementMonth]) ON [PRIMARY]
GO
