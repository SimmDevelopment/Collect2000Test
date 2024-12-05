CREATE TABLE [dbo].[salesman]
(
[code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fees] [money] NULL,
[collections] [money] NULL,
[mtdnumberplaced] [float] NULL,
[mtddollarsplaced] [money] NULL,
[ytdnumberplaced] [float] NULL,
[ytddollarsplaced] [money] NULL,
[mtdfees] [money] NULL,
[mtdcollections] [money] NULL,
[ytdfees] [money] NULL,
[ytdcollections] [money] NULL,
[ID] [int] NOT NULL IDENTITY(0, 1)
) ON [PRIMARY]
GO
