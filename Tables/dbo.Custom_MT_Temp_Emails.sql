CREATE TABLE [dbo].[Custom_MT_Temp_Emails]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[AgencyId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactRecordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NickName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAvailability] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredEmailAddressInd] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsentToContact] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TypeOfConsent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceOfConsent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfConsent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_MT_Temp_Emails] ADD CONSTRAINT [PK_Custom_M&T_Temp_Emails] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
