CREATE TABLE [dbo].[ccj_backup_job]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CategoryID] [int] NULL,
[ForeignKeyID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScheduleID] [int] NULL,
[JobStatusID] [int] NULL,
[LastRunDateTime] [datetime] NULL,
[NextRunDateTime] [datetime] NULL,
[LastRunOutcome] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [bit] NULL,
[Scheduled] [bit] NULL,
[EmailUponError] [bit] NULL,
[ErrorEmailAddress] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailUponSuccess] [bit] NULL,
[SuccessEmailAddress] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PickupAllPending] [bit] NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config] [xml] NULL
) ON [PRIMARY]
GO
