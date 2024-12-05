CREATE TABLE [dbo].[NewBizBDebtBuyerItems]
(
[Number] [int] NOT NULL,
[PurchasePrice] [money] NULL,
[WarrantyReimbursementAmount] [money] NULL,
[WarrantyClaimMade] [datetime] NULL,
[SalesPrice] [money] NULL,
[CourtCostAdvanced] [bit] NULL,
[SkipCostsIncurred] [bit] NULL,
[OriginalCreditor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeOffdate] [datetime] NULL,
[OrderDate] [datetime] NULL
) ON [PRIMARY]
GO
