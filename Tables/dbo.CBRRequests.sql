CREATE TABLE [dbo].[CBRRequests]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NULL,
[Entered] [datetime] NULL,
[ReportCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleInitial] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameSuffix] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetNumber] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetDir] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
