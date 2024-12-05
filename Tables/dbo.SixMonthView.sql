CREATE TABLE [dbo].[SixMonthView]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TheYear] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TheMonth] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlacedNumber] [int] NULL,
[PlacedDollars] [money] NULL,
[PlacedAvg] [money] NULL,
[Collections] [money] NULL,
[Fees] [money] NULL,
[OpenNumber] [int] NULL,
[OpenDollars] [money] NULL
) ON [PRIMARY]
GO
