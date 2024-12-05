CREATE TABLE [dbo].[FirstData_Closes_History]
(
[Number] [int] NOT NULL,
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReturnCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Narrative1] [varchar] (140) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Closed] [datetime] NOT NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateRan] [datetime] NOT NULL
) ON [PRIMARY]
GO
