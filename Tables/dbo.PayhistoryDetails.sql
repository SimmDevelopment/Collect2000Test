CREATE TABLE [dbo].[PayhistoryDetails]
(
[PayhistoryID] [int] NOT NULL,
[PodID] [int] NOT NULL,
[PmtDate] [datetime] NOT NULL,
[PaidAmount] [money] NOT NULL,
[FeeAmount] [money] NOT NULL,
[BatchType] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AcctID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PayhistoryDetails] ADD CONSTRAINT [PK_PayhistoryDetails] PRIMARY KEY NONCLUSTERED ([PayhistoryID], [PodID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PayhistoryDetails_2] ON [dbo].[PayhistoryDetails] ([AcctID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PayhistoryDetails] ON [dbo].[PayhistoryDetails] ([PayhistoryID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PayhistoryDetails_1] ON [dbo].[PayhistoryDetails] ([PodID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number from Master', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryDetails', 'COLUMN', N'AcctID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of Batch', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryDetails', 'COLUMN', N'BatchType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fee Amount', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryDetails', 'COLUMN', N'FeeAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Payment Amount', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryDetails', 'COLUMN', N'PaidAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'UID from Payhistory', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryDetails', 'COLUMN', N'PayhistoryID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Payment Date', 'SCHEMA', N'dbo', 'TABLE', N'PayhistoryDetails', 'COLUMN', N'PmtDate'
GO
