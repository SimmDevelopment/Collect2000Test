CREATE TABLE [dbo].[WebAccess_Log]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ReportID] [int] NULL,
[LogDate] [datetime] NOT NULL CONSTRAINT [DF__WebAccess__LogDa__492B32F1] DEFAULT (getdate()),
[Message] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserID] [int] NULL,
[LogEventType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WebAccess_Log] ADD CONSTRAINT [PK_WebAccess_Log] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
