CREATE TABLE [dbo].[Custom_Automate_Log]
(
[LogID] [bigint] NOT NULL IDENTITY(1, 1),
[ProcessType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProcessName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProcessID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StepName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlowName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartTime] [datetime2] NULL,
[EndTime] [datetime2] NULL,
[Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data2] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data3] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime2] NULL CONSTRAINT [DF__Custom_Au__Creat__7F880EF9] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Automate_Log] ADD CONSTRAINT [PK__Custom_A__5E5499A8C562D9F9] PRIMARY KEY CLUSTERED ([LogID]) ON [PRIMARY]
GO
