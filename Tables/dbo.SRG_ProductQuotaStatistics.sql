CREATE TABLE [dbo].[SRG_ProductQuotaStatistics]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SRG_ProductID] [int] NOT NULL,
[SRG_ProductQuotaPeriodID] [int] NOT NULL,
[Counter] [int] NOT NULL,
[Quota] [int] NOT NULL,
[QuotaOriginal] [int] NOT NULL,
[UserID] [int] NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__SRG_ProductQuotaStatistics__Created] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SRG_ProductQuotaStatistics__CreatedBy] DEFAULT (suser_sname()),
[Updated] [datetime] NOT NULL CONSTRAINT [DF__SRG_ProductQuotaStatistics__Updated] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SRG_ProductQuotaStatistics__UpdatedBy] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductQuotaStatistics] ADD CONSTRAINT [PK_SRG_ProductQuotaStatistics] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductQuotaStatistics_customer] ON [dbo].[SRG_ProductQuotaStatistics] ([Customer]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductQuotaStatistics_desk] ON [dbo].[SRG_ProductQuotaStatistics] ([Desk]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductQuotaStatistics_SRG_ProductID] ON [dbo].[SRG_ProductQuotaStatistics] ([SRG_ProductID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductQuotaStatistics_UserID] ON [dbo].[SRG_ProductQuotaStatistics] ([UserID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductQuotaStatistics] ADD CONSTRAINT [FK_SRG_ProductQuotaStatistics_SRG_Product] FOREIGN KEY ([SRG_ProductID]) REFERENCES [dbo].[SRG_Product] ([ID])
GO
ALTER TABLE [dbo].[SRG_ProductQuotaStatistics] ADD CONSTRAINT [FK_SRG_ProductQuotaStatistics_SRG_ProductQuotaPeriod] FOREIGN KEY ([SRG_ProductQuotaPeriodID]) REFERENCES [dbo].[SRG_ProductQuotaPeriod] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tracks the usage of a product for the time period represented in SRG_ProductQuotaPeriod.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The number of times the product was requested for the given entity (userid, customer, or desk). Incremented on each request for the product.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'Counter'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time this record was created.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user that created this record.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The customer code for which this record applies. Only 1 of the 3 fields UserId, Customer, and Desk, will have a value, the other 2 will be null.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The desk code for which this record applies. Only 1 of the 3 fields UserId, Customer, and Desk, will have a value, the other 2 will be null.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is the maximum value of counter. When counter meets or exceeds quota then no more requests are granted to the user/desk/customer for the product. The value may be increased for the time period.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'Quota'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When this record is created, this is the value of the quota at that time. The quota value may be increased for the time period, but this value will remain.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'QuotaOriginal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to the SRG_Product table that this record is associated with.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'SRG_ProductID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to SRG_ProductQuotaPeriod record that this record is associated with.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'SRG_ProductQuotaPeriodID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date this record was most recently updated.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'Updated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user that most recently updated this record.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'UpdatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The userid for the user to which this record applies. Only 1 of the 3 fields UserId, Customer, and Desk, will have a value, the other 2 will be null.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaStatistics', 'COLUMN', N'UserID'
GO
