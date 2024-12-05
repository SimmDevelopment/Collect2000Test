CREATE TABLE [dbo].[custom_automate_run_history]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[run_id] [int] NULL,
[process_name] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ordinal] [int] NULL,
[job_name] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[job_id] [int] NULL,
[job_started] [int] NULL,
[max_history_id] [int] NULL,
[outcomeid] [int] NULL,
[outcomemessage] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime2] NULL,
[DateUpdated] [datetime2] NULL,
[Param1] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Param2] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Param3] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateArchived] [datetime2] NULL
) ON [PRIMARY]
GO
