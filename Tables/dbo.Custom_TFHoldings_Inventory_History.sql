CREATE TABLE [dbo].[Custom_TFHoldings_Inventory_History]
(
[ID] [int] NOT NULL,
[ProductionDate] [date] NULL,
[Total_Inventory] [int] NULL,
[Accts_Placed] [int] NULL,
[Amt_Placed] [money] NULL,
[Stream] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
