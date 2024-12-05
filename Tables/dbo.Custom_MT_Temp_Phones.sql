CREATE TABLE [dbo].[Custom_MT_Temp_Phones]
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
[PhoneNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Extension] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Priority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneFormat] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneAvailability] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredPhoneNumberInd] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotContact] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneTimezone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerConsent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerConsentType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerConsentSource] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfConsent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartyGivingConsent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_MT_Temp_Phones] ADD CONSTRAINT [PK_Custom_M&T_Temp_Phones] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
