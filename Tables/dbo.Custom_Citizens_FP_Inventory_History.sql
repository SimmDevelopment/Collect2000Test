CREATE TABLE [dbo].[Custom_Citizens_FP_Inventory_History]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ProductionDate] [date] NULL,
[Total_Inventory] [int] NULL,
[Accts_Placed] [int] NULL,
[Amt_Placed] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Citizens_FP_Inventory_History] ADD CONSTRAINT [PK_Custom_Citizens_FP_Inventory_History] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
