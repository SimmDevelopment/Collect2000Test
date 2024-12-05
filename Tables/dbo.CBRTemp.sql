CREATE TABLE [dbo].[CBRTemp]
(
[Number] [int] NOT NULL,
[ActivityDate] [datetime] NOT NULL,
[ActivityType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Balance] [money] NOT NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateLastPymt] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RptEquifax] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RptExperian] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RptTransUnion] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RptInnovis] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RecordSent] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
