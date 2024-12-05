CREATE TABLE [dbo].[Custom_Automate_Master_Flow_History]
(
[ID] [int] NOT NULL,
[Flow_Name] [varchar] (225) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ScheduledDate] [datetime] NOT NULL,
[Last_Run_Date] [datetime] NOT NULL,
[Status] [int] NOT NULL
) ON [PRIMARY]
GO
