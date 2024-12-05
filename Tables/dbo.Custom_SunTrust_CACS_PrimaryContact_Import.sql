CREATE TABLE [dbo].[Custom_SunTrust_CACS_PrimaryContact_Import]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[AgencyId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNum] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactRecType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameRelationship] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LeadContactInd] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponsibleParty] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredCurrency] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactRecType1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prefix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirsstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaternalName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NationalIDNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NationalIDNumberType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofBirth] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredContactMethod1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredContactMethod2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferredContactMethod3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RighttoPrivacy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISOLanguageCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressDisplayFormat] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Employer] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerSinceDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedStatus1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedStatus2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedStatus3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedStatus4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedStatus5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedDate1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedDate2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedDate3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedDate4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedDate5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedText1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedText2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedText3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedText4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedText5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SearchName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedSearch1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefinedSearch2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateLastVerified] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressExternalKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NickName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressRelationship] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonalAddressFrom] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonalAddressTo] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressBlockInd] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrefferredAddressInd] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditBureauAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditBureauAddressIndicatorDateUpdated] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriAddressChangeDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_SunTrust_CACS_PrimaryContact_Import] ADD CONSTRAINT [PK_Custom_SunTrust_CACS_PrimaryContact_Import] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
