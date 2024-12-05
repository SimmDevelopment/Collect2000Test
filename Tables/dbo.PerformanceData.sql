CREATE TABLE [dbo].[PerformanceData]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Received] [datetime] NULL,
[PMonth] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pyear] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlacedNumber] [int] NULL,
[PlacedDollars] [money] NULL,
[PlacedAvg] [money] NULL,
[Adjustments] [money] NULL,
[CollectionsTotal] [money] NULL,
[CollectionsThisMonth] [money] NULL,
[CollectionslastMonth] [money] NULL,
[CollectionsMonth1] [money] NULL,
[CollectionsMonth2] [money] NULL,
[CollectionsMonth3] [money] NULL,
[CollectionsMonth4] [money] NULL,
[CollectionsMonth5] [money] NULL,
[CollectionsMonth6] [money] NULL,
[CollectionsMonth7] [money] NULL,
[CollectionsMonth8] [money] NULL,
[CollectionsMonth9] [money] NULL,
[CollectionsMonth10] [money] NULL,
[CollectionsMonth11] [money] NULL,
[CollectionsMonth12] [money] NULL,
[CollectionsMonth99] [money] NULL,
[FeesTotal] [money] NULL,
[FeesThisMonth] [money] NULL,
[FeesLastMonth] [money] NULL,
[FeesMonth1] [money] NULL,
[FeesMonth2] [money] NULL,
[FeesMonth3] [money] NULL,
[FeesMonth4] [money] NULL,
[FeesMonth5] [money] NULL,
[FeesMonth6] [money] NULL,
[FeesMonth7] [money] NULL,
[FeesMonth8] [money] NULL,
[FeesMonth9] [money] NULL,
[FeesMonth10] [money] NULL,
[FeesMonth11] [money] NULL,
[FeesMonth12] [money] NULL,
[FeesMonth99] [money] NULL,
[PIENumber] [int] NULL,
[PIEDollars] [money] NULL,
[CCRNumber] [int] NULL,
[CCRDollars] [money] NULL,
[PIFNumber] [int] NULL,
[SIFNumber] [int] NULL,
[BANNumber] [int] NULL,
[ReturnedNumber] [int] NULL,
[ReturnedDollars] [money] NULL,
[Cum1] [money] NULL,
[Cum2] [money] NULL,
[Cum3] [money] NULL,
[Cum4] [money] NULL,
[Cum5] [money] NULL,
[Cum6] [money] NULL,
[Cum7] [money] NULL,
[Cum8] [money] NULL,
[Cum9] [money] NULL,
[Cum10] [money] NULL,
[Cum11] [money] NULL,
[Cum12] [money] NULL,
[Cum99] [money] NULL,
[Actual1] [money] NULL,
[Actual2] [money] NULL,
[Actual3] [money] NULL,
[Actual4] [money] NULL,
[Actual5] [money] NULL,
[Actual6] [money] NULL,
[Actual7] [money] NULL,
[Actual8] [money] NULL,
[Actual9] [money] NULL,
[Actual10] [money] NULL,
[Actual11] [money] NULL,
[Actual12] [money] NULL,
[Actual99] [money] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PerformanceData] ON [dbo].[PerformanceData] ([Customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PerformanceData_1] ON [dbo].[PerformanceData] ([Customer], [Received]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer from Master', 'SCHEMA', N'dbo', 'TABLE', N'PerformanceData', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The total dollar amounts placed', 'SCHEMA', N'dbo', 'TABLE', N'PerformanceData', 'COLUMN', N'PlacedDollars'
GO
EXEC sp_addextendedproperty N'MS_Description', N'total number of accounts placed', 'SCHEMA', N'dbo', 'TABLE', N'PerformanceData', 'COLUMN', N'PlacedNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month Accounts were placed', 'SCHEMA', N'dbo', 'TABLE', N'PerformanceData', 'COLUMN', N'PMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Year Accounts were placed', 'SCHEMA', N'dbo', 'TABLE', N'PerformanceData', 'COLUMN', N'Pyear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Received Date from Master', 'SCHEMA', N'dbo', 'TABLE', N'PerformanceData', 'COLUMN', N'Received'
GO
