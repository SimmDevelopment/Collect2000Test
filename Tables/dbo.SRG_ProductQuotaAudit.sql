CREATE TABLE [dbo].[SRG_ProductQuotaAudit]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SRG_ProductQuotaStatisticsID] [int] NOT NULL,
[QuotaOld] [int] NOT NULL,
[QuotaNew] [int] NOT NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__SRG_ProductQuotaAudit__Created] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SRG_ProductQuotaAudit__CreatedBy] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductQuotaAudit] ADD CONSTRAINT [PK_SRG_ProductQuotaAudit] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductQuotaAudit_SRG_ProductQuotaStatisticsID] ON [dbo].[SRG_ProductQuotaAudit] ([SRG_ProductQuotaStatisticsID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductQuotaAudit] ADD CONSTRAINT [FK_SRG_ProductQuotaAudit_SRG_ProductQuotaStatistics] FOREIGN KEY ([SRG_ProductQuotaStatisticsID]) REFERENCES [dbo].[SRG_ProductQuotaStatistics] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Audit any changes to the SRG_ProductQuotaStatistics.Quota value.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaAudit', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time this record was created.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaAudit', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user that created this record.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaAudit', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaAudit', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRG_ProductQuotaStatistics.Quota value after the change was made.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaAudit', 'COLUMN', N'QuotaNew'
GO
EXEC sp_addextendedproperty N'MS_Description', N'SRG_ProductQuotaStatistics.Quota value before the change was made.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaAudit', 'COLUMN', N'QuotaOld'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to the SRG_ProductQuotaStatistics table that this record is associated with.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductQuotaAudit', 'COLUMN', N'SRG_ProductQuotaStatisticsID'
GO
