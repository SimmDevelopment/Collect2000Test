CREATE TABLE [dbo].[FirstDataAudits]
(
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Balance] [money] NULL,
[Address1] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollectorCode] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number] [int] NULL,
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastPaid] [datetime] NULL,
[Closed] [datetime] NULL
) ON [PRIMARY]
GO
