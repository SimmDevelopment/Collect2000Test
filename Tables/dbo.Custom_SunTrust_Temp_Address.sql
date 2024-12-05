CREATE TABLE [dbo].[Custom_SunTrust_Temp_Address]
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
[AddressTimezone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChangeDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_SunTrust_Temp_Address] ADD CONSTRAINT [PK_Custom_SunTrust_Temp_Address] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
