CREATE TABLE [dbo].[CustomCustGroupLtrSeries]
(
[CustomCustGroupLtrSeriesID] [int] NOT NULL IDENTITY(1, 1),
[CustomCustGroupID] [int] NOT NULL,
[LtrSeriesID] [int] NOT NULL,
[MinBalance] [money] NOT NULL CONSTRAINT [DF_CustomCustGroupLtrSeries_MinBalance] DEFAULT (0),
[MaxBalance] [money] NOT NULL CONSTRAINT [DF_CustomCustGroupLtrSeries_MaxBalance] DEFAULT (0),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_CustomCustGroupLtrSeries_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_CustomCustGroupLtrSeries_DateUpdated] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomCustGroupLtrSeries] ADD CONSTRAINT [PK_CustomCustGroupLtrSeries] PRIMARY KEY CLUSTERED ([CustomCustGroupLtrSeriesID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom groups may be created for letter series in order to apply the same letter allowances to every customer within the group.', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLtrSeries', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of Parent CustomCustGroup', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLtrSeries', 'COLUMN', N'CustomCustGroupID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLtrSeries', 'COLUMN', N'CustomCustGroupLtrSeriesID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp created', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLtrSeries', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLtrSeries', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of LtrSeries to be assigned', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLtrSeries', 'COLUMN', N'LtrSeriesID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Maximum balance allowed on debtor account for letter to be generated', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLtrSeries', 'COLUMN', N'MaxBalance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Minimum balance allowed on debtor account for letter to be generated', 'SCHEMA', N'dbo', 'TABLE', N'CustomCustGroupLtrSeries', 'COLUMN', N'MinBalance'
GO
