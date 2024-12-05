CREATE TABLE [dbo].[Arrangements]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CreatedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Arrangeme__Creat__31D2CC4D] DEFAULT (getdate()),
[SpreadAlgorithm] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlatSurcharge] [money] NULL,
[PercentageSurcharge] [money] NULL,
[AddedFlatSurcharge] [money] NULL,
[AddedPercentageSurcharge] [money] NULL,
[ManualSurcharge] [bit] NOT NULL,
[ArrangementFee] [money] NULL,
[PaymentFrequency] [tinyint] NULL,
[StartDate] [datetime] NULL,
[FirstPaymentAmount] [money] NULL,
[PaymentAmount] [money] NULL,
[NumberOfPayments] [smallint] NULL,
[IsSettlement] [bit] NULL,
[ReviewFlag] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Arrangements] ADD CONSTRAINT [pk_Arrangements] PRIMARY KEY NONCLUSTERED ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used to setup payment arrangements on Accounts for Promises, Checks by phone and Credit Cards.', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surcharge amount added to Payment Amount', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', 'COLUMN', N'AddedFlatSurcharge'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Percentage of Total added to payment amount', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', 'COLUMN', N'AddedPercentageSurcharge'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A fee that applies to the entire arrangement (i.e. an Extension Fee).', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', 'COLUMN', N'ArrangementFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon ', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Timestamp of Arrangement', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', 'COLUMN', N'CreatedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surcharge amount deducted from payment amount', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', 'COLUMN', N'FlatSurcharge'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manual override surcharge amount', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', 'COLUMN', N'ManualSurcharge'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Percentage of Total deducted from payment amount ', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', 'COLUMN', N'PercentageSurcharge'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag that indicates this arrangement needs to be reviewed before it continues. Current Flags: Inactive Payments', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', 'COLUMN', N'ReviewFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'XML string containing the defined spead algorthm', 'SCHEMA', N'dbo', 'TABLE', N'Arrangements', 'COLUMN', N'SpreadAlgorithm'
GO
