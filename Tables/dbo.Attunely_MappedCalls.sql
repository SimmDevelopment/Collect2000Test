CREATE TABLE [dbo].[Attunely_MappedCalls]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CallKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DialType_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CallerPhone] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CalledPhone] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredLanguage_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartTime] [datetime2] NOT NULL,
[Duration] [bigint] NOT NULL,
[AgentKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_MappedCalls] ADD CONSTRAINT [PK_Attunely_MappedCalls] PRIMARY KEY CLUSTERED ([AccountKey], [CallKey]) ON [PRIMARY]
GO
