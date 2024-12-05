CREATE TABLE [dbo].[Custom_MT_CACS_Contact_Phone_Maintenance]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AgencyID] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNumber] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactID] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactRecType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalKey] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NickName] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Extension] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Priority] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneFormat] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneAvailbility] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredPhoneIND] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoNotContact] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerConsent] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerConsentType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerConsentSource] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfConsent] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartyGivingConsent] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_MT_CACS_Contact_Phone_Maintenance] ADD CONSTRAINT [PK_Custom_MT_CACS_Contact_Phone_Maintenance] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
