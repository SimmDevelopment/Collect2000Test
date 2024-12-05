CREATE TABLE [dbo].[AIM_Report]
(
[ReportId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Configuration] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
