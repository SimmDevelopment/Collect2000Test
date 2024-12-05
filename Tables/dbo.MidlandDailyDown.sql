CREATE TABLE [dbo].[MidlandDailyDown]
(
[RecordType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MCMAccount] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ForwFile] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AgencyFile] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ForwID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Wholerecord] [varchar] (1500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Comment] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WhenLoaded] [datetime] NOT NULL
) ON [PRIMARY]
GO
