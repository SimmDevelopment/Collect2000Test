CREATE TABLE [dbo].[Custom_Truist_Email_Campaign_Results]
(
[CampaignDate] [datetime] NULL,
[Clicks] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Bounces] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Unsubscribed] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO