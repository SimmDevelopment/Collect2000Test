CREATE TABLE [dbo].[Attunely_Events]
(
[EventKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventTime] [datetime2] NOT NULL,
[DebtKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Metadata] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Events] ADD CONSTRAINT [PK_Attunely_Events] PRIMARY KEY CLUSTERED ([AccountKey], [EventKey]) ON [PRIMARY]
GO
