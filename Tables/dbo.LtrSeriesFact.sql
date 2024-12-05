CREATE TABLE [dbo].[LtrSeriesFact]
(
[LtrSeriesFactID] [int] NOT NULL IDENTITY(1, 1),
[LtrSeriesID] [int] NULL,
[CustomerID] [int] NULL,
[MinBalance] [money] NOT NULL CONSTRAINT [DF_LtrSeriesFact_MinBalance] DEFAULT (0),
[MaxBalance] [money] NOT NULL CONSTRAINT [DF_LtrSeriesFact_MaxBalance] DEFAULT (0),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_LtrSeriesFact_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_LtrSeriesFact_DateUpdated] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LtrSeriesFact] ADD CONSTRAINT [PK_LtrSeriesFact] PRIMARY KEY CLUSTERED ([LtrSeriesFactID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UIX_LtrSeriesFact_LtrSeriesID_CustomerID] ON [dbo].[LtrSeriesFact] ([LtrSeriesID], [CustomerID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used to relate or assign ltrSeries to the respective CustomCustGroupLtrSeries', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesFact', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer ID of CustomCustGroupLtrSeries', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesFact', 'COLUMN', N'CustomerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp created', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesFact', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesFact', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesFact', 'COLUMN', N'LtrSeriesFactID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of respective LtrSeries', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesFact', 'COLUMN', N'LtrSeriesID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Maximum balance (in dollars) for accounts to have the letter series applied', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesFact', 'COLUMN', N'MaxBalance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Minimum balance  for accounts to have the letter series applied', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeriesFact', 'COLUMN', N'MinBalance'
GO
