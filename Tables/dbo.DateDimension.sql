CREATE TABLE [dbo].[DateDimension]
(
[DateKey] [int] NOT NULL,
[Date] [date] NOT NULL,
[Day] [tinyint] NOT NULL,
[DaySuffix] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Weekday] [tinyint] NOT NULL,
[WeekDayName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsWeekend] [bit] NOT NULL,
[IsHoliday] [bit] NOT NULL,
[HolidayText] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS SPARSE NULL,
[DOWInMonth] [tinyint] NOT NULL,
[DayOfYear] [smallint] NOT NULL,
[WeekOfMonth] [tinyint] NOT NULL,
[WeekOfYear] [tinyint] NOT NULL,
[ISOWeekOfYear] [tinyint] NOT NULL,
[Month] [tinyint] NOT NULL,
[MonthName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Quarter] [tinyint] NOT NULL,
[QuarterName] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Year] [int] NOT NULL,
[MMYYYY] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MonthYear] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FirstDayOfMonth] [date] NOT NULL,
[LastDayOfMonth] [date] NOT NULL,
[FirstDayOfQuarter] [date] NOT NULL,
[LastDayOfQuarter] [date] NOT NULL,
[FirstDayOfYear] [date] NOT NULL,
[LastDayOfYear] [date] NOT NULL,
[FirstDayOfNextMonth] [date] NOT NULL,
[FirstDayOfNextYear] [date] NOT NULL,
[FiscalYear] [smallint] NOT NULL,
[FiscalMonth] [tinyint] NOT NULL,
[FiscalWeek] [tinyint] NOT NULL,
[FiscalDay] [tinyint] NOT NULL,
[FiscalFirstDayOfMonth] [date] NOT NULL,
[FiscalLastDayOfMonth] [date] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DateDimension] ADD CONSTRAINT [PK__DateDime__40DF45E33ACC9741] PRIMARY KEY CLUSTERED ([DateKey]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DateDimension_FiscalData] ON [dbo].[DateDimension] ([FiscalYear], [FiscalMonth], [FiscalDay], [Date]) INCLUDE ([FiscalFirstDayOfMonth], [FiscalLastDayOfMonth]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dimensional Table holding date data.  Used to speed up and simplify date based queries.', 'SCHEMA', N'dbo', 'TABLE', N'DateDimension', NULL, NULL
GO
