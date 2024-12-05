CREATE TABLE [dbo].[TimeClockTable]
(
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Date] [datetime] NULL,
[ClockInTime] [datetime] NULL,
[ClockOutTime] [datetime] NULL,
[Totaltime] [float] NULL,
[ClockedIn] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UID] [float] NULL
) ON [PRIMARY]
GO
