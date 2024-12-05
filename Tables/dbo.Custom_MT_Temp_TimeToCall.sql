CREATE TABLE [dbo].[Custom_MT_Temp_TimeToCall]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[AgencyId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactRecType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimePref] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Monday] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tuesday] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Wednesday] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Thursday] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Friday] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Saturday] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sunday] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AnyTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeZone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_MT_Temp_TimeToCall] ADD CONSTRAINT [PK_M&T_Temp_TimeToCall] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
