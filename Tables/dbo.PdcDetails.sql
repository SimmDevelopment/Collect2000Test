CREATE TABLE [dbo].[PdcDetails]
(
[PdcID] [int] NOT NULL,
[AccountID] [int] NOT NULL,
[Amount] [money] NOT NULL,
[Settlement] [bit] NOT NULL,
[ProjectedCurrent] [money] NOT NULL,
[ProjectedRemaining] [money] NOT NULL,
[Surcharge] [money] NOT NULL,
[ProjectedFee] [money] NULL,
[ProjectedCollectorFee] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PdcDetails] ADD CONSTRAINT [pk_PdcDetails] PRIMARY KEY NONCLUSTERED ([PdcID], [AccountID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PdcDetails_AccountID] ON [dbo].[PdcDetails] ([AccountID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'PdcDetails', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of Post date', 'SCHEMA', N'dbo', 'TABLE', N'PdcDetails', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identifier for each record', 'SCHEMA', N'dbo', 'TABLE', N'PdcDetails', 'COLUMN', N'PdcID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Projected Collector Fee for the this payment', 'SCHEMA', N'dbo', 'TABLE', N'PdcDetails', 'COLUMN', N'ProjectedCollectorFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance form Master', 'SCHEMA', N'dbo', 'TABLE', N'PdcDetails', 'COLUMN', N'ProjectedCurrent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Projected Fee associated with this payment', 'SCHEMA', N'dbo', 'TABLE', N'PdcDetails', 'COLUMN', N'ProjectedFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Projected Current Balance after payment', 'SCHEMA', N'dbo', 'TABLE', N'PdcDetails', 'COLUMN', N'ProjectedRemaining'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Is this a Settlement Amount', 'SCHEMA', N'dbo', 'TABLE', N'PdcDetails', 'COLUMN', N'Settlement'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of Surcharge for PDC', 'SCHEMA', N'dbo', 'TABLE', N'PdcDetails', 'COLUMN', N'Surcharge'
GO
