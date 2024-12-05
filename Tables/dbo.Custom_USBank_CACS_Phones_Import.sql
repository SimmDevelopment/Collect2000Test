CREATE TABLE [dbo].[Custom_USBank_CACS_Phones_Import]
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
[PhoneType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneFormat] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneAvailability] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredPhoneNumberInd] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotContact] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
ALTER TABLE [dbo].[Custom_USBank_CACS_Phones_Import] ADD CONSTRAINT [PK_Custom_USBank_CACS_Phones_Import] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
