CREATE TABLE [dbo].[Attunely_Calls]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CallKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Initiation_Direction_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Initiation_DialType_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Initiation_EndpointType_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Initiation_CallerPhone] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Initiation_CalledPhone] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Initiation_Pickup_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Disposition_PreferredLanguage_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Disposition_Notes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartTime] [datetime2] NOT NULL,
[Duration] [bigint] NOT NULL,
[AgentKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Calls] ADD CONSTRAINT [PK_Attunely_Calls] PRIMARY KEY CLUSTERED ([AccountKey], [CallKey]) ON [PRIMARY]
GO
