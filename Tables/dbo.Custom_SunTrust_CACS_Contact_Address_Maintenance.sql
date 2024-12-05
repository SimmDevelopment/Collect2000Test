CREATE TABLE [dbo].[Custom_SunTrust_CACS_Contact_Address_Maintenance]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AgencyId] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNumber] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactId] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactRecordType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalKey] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionCode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NickName] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressRelationship] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressStatus] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonalAddressFrom] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonalAddressTo] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressBlockInd] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrefferredAddressInd] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditBureauAddress] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditBureauAddressIndicatorDateUpdated] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressLine3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTimezone] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeDate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_SunTrust_CACS_Contact_Address_Maintenance] ADD CONSTRAINT [PK_Custom_SunTrust_CACS_Contact_Address_Maintenance] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
