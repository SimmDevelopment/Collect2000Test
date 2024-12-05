CREATE TABLE [dbo].[LtrSeries]
(
[LtrSeriesID] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_LtrSeries_Active] DEFAULT (1),
[IsNewBusiness] [bit] NOT NULL CONSTRAINT [DF_LtrSeries_IsNewBusiness] DEFAULT (1),
[MinBalance] [money] NOT NULL CONSTRAINT [DF_LtrSeries_MinBalance] DEFAULT (0),
[MaxBalance] [money] NOT NULL CONSTRAINT [DF_LtrSeries_MaxBalance] DEFAULT (0),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_LtrSeries_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_LtrSeries_DateUpdated] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LtrSeries] ADD CONSTRAINT [PK_LtrSeries] PRIMARY KEY CLUSTERED ([LtrSeriesID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude allows your agency to define a series of letters to be sent to debtors based on the receive date. The letter series is scheduled when new business is entered into the system and is available for viewing in the account work form.  This table defines the respective series.', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeries', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active - inactive indicator', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeries', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp created', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeries', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeries', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descriptive name of letter series', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeries', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set restricts the letter series to new business only', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeries', 'COLUMN', N'IsNewBusiness'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key ID', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeries', 'COLUMN', N'LtrSeriesID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Maximum balance (in dollars) for accounts to have the letter series applied', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeries', 'COLUMN', N'MaxBalance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Minimum balance  for accounts to have the letter series applied', 'SCHEMA', N'dbo', 'TABLE', N'LtrSeries', 'COLUMN', N'MinBalance'
GO
