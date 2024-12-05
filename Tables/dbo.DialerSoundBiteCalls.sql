CREATE TABLE [dbo].[DialerSoundBiteCalls]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[ResultFileUID] [int] NOT NULL,
[LatitudeInstanceCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_DialerSoundBiteCalls_LatitudeInstanceCode] DEFAULT ('master'),
[WorkPhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CellPhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Other1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Other2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Other3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Other4] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileNumber] [int] NOT NULL,
[CampaignCd] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DialerPhoneNumber] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CallDateTime] [datetime] NOT NULL,
[CallSeconds] [int] NOT NULL,
[OurResult] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CallPass] [int] NULL,
[DCCallCenter] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DCDirectConnectTalkSeconds] [int] NOT NULL,
[DCHoldSeconds] [int] NULL,
[DCRingSeconds] [int] NULL,
[DCDirectConnectDate] [datetime] NULL,
[DC] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HOLD] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RPV] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerSoundBiteCalls] ADD CONSTRAINT [PK_DialerSoundBiteCalls] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
