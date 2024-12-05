CREATE TABLE [dbo].[FirstData_AccountActivity]
(
[number] [int] NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[message] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RunDate] [datetime] NOT NULL,
[FileName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
