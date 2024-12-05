CREATE TABLE [dbo].[LtrSeriesQueue]
(
[LtrSeriesQueueID] [int] NOT NULL IDENTITY(1, 1),
[LtrSeriesConfigID] [int] NOT NULL,
[DateToRequest] [datetime] NOT NULL,
[DateRequested] [datetime] NOT NULL CONSTRAINT [DF_LtrSeriesQueue_DateRequested] DEFAULT ('1/1/1753 12:00:00'),
[AccountID] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[PrimaryDebtorID] [int] NOT NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_LtrSeriesQueue_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_LtrSeriesQueue_DateUpdated] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LtrSeriesQueue] ADD CONSTRAINT [PK_LtrSeriesQueue] PRIMARY KEY CLUSTERED ([LtrSeriesQueueID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used by Letter console to display and request queued letters ', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesQueue', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesQueue', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp created', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesQueue', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Actual Date Requested', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesQueue', 'COLUMN', N'DateRequested'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Scheduled date to request', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesQueue', 'COLUMN', N'DateToRequest'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesQueue', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DebtorID receiving letter', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesQueue', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of parent LtrSeriesConfigID', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesQueue', 'COLUMN', N'LtrSeriesConfigID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key ID', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesQueue', 'COLUMN', N'LtrSeriesQueueID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary DebtorID on account', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesQueue', 'COLUMN', N'PrimaryDebtorID'
GO
