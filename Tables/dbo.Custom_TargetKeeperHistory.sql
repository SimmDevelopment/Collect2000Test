CREATE TABLE [dbo].[Custom_TargetKeeperHistory]
(
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dtstamp] [datetime] NULL CONSTRAINT [DF_Custom_TargetKeeperHistory_dtstamp] DEFAULT (getdate())
) ON [PRIMARY]
GO
