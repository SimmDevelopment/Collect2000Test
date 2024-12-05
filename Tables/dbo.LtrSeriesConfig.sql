CREATE TABLE [dbo].[LtrSeriesConfig]
(
[LtrSeriesConfigID] [int] NOT NULL IDENTITY(1, 1),
[LtrSeriesID] [int] NOT NULL,
[LetterID] [int] NULL,
[DaysToWait] [int] NULL,
[ToPrimaryDebtor] [bit] NOT NULL CONSTRAINT [DF_LtrSeriesConfig_ToPrimaryDebtor] DEFAULT (1),
[ToCoDebtors] [bit] NOT NULL CONSTRAINT [DF_LtrSeriesConfig_ToCoDebtors] DEFAULT (1),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_LtrSeriesConfig_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_LtrSeriesConfig_DateUpdated] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LtrSeriesConfig] ADD CONSTRAINT [PK_LtrSeriesConfig] PRIMARY KEY CLUSTERED ([LtrSeriesConfigID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Configuration table for the Letter Series', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesConfig', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp created', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesConfig', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesConfig', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of days to wait prior to generating letter request', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesConfig', 'COLUMN', N'DaysToWait'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of parent letter included in the series', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesConfig', 'COLUMN', N'LetterID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesConfig', 'COLUMN', N'LtrSeriesConfigID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of parent LtrSeries', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesConfig', 'COLUMN', N'LtrSeriesID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set generates letter to all non primary debtors (co-debtors) on account', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesConfig', 'COLUMN', N'ToCoDebtors'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set generates letter for primary DebtotID on account', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesConfig', 'COLUMN', N'ToPrimaryDebtor'
GO
