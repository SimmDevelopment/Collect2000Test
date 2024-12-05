CREATE TABLE [dbo].[CBRRequestClose]
(
[Number] [int] NOT NULL,
[ActivityDate] [datetime] NOT NULL,
[ActivityType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Balance] [money] NULL,
[DateSent] [datetime] NULL
) ON [PRIMARY]
GO
