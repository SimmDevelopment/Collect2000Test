CREATE TABLE [dbo].[Custom_Emails_Campaign_Master_Result_Table]
(
[Year] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tag1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDate] [datetime] NULL,
[TotalClicks] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UniqueOpens] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UniqueClicks] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bounced] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Unsubscribed] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
