CREATE TABLE [dbo].[SRG_ProductQuotaPeriod]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Active] [bit] NOT NULL CONSTRAINT [DF__SRG_ProductQuotaPeriod__Active] DEFAULT ((1)),
[DeactivedDate] [datetime] NULL CONSTRAINT [DF__SRG_ProductQuotaPeriod__DeactivedDate] DEFAULT (getdate()),
[QuotaGroup] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MatchingAlgorithm] [int] NOT NULL CONSTRAINT [DF__SRG_ProductQuotaPeriod__MatchingAlgorithm] DEFAULT ((0)),
[SysMonth] [tinyint] NULL,
[SysYear] [tinyint] NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__SRG_ProductQuotaPeriod__Created] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SRG_ProductQuotaPeriod__CreatedBy] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductQuotaPeriod] ADD CONSTRAINT [PK_SRG_ProductQuotaPeriod] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductQuotaPeriod_QuotaGroup] ON [dbo].[SRG_ProductQuotaPeriod] ([QuotaGroup]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies a time span that applies to a product group''s quota.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Is this record used anymore? 0 ==> not active, 1 ==> active.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time this record was created.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user that created this record.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The datetime stamp that a records active value was set to 0.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', 'COLUMN', N'DeactivedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date after which this record ceases to take effect. Time value is always implicitly 23:59:99...', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', 'COLUMN', N'EndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates the type of quota logic to apply to a request for a product. 0 ==> request date is simply the current system month and year (start and end dates are ignored). 1 ==> indicates the request (created) date is current date which is then compared to start and end dates.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', 'COLUMN', N'MatchingAlgorithm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The QuotaGroup that this record applies to. See SRG_Product.QuotaGroup.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', 'COLUMN', N'QuotaGroup'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that this record begins to take effect. Time value is always implicitly 00:00:00 (Midnight).', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', 'COLUMN', N'StartDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The system month that this record applies to. Valid values are 1-12.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', 'COLUMN', N'SysMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The system year that this record applies to.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaPeriod', 'COLUMN', N'SysYear'
GO
