CREATE TABLE [dbo].[Attunely_ContactAddresses]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AddressKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Address_Line1] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Line2] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Line3] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_City] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_State] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_PostalCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Country_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Party_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPartyDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL,
[Deleted] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_ContactAddresses] ADD CONSTRAINT [PK_Attunely_ContactAddresses] PRIMARY KEY CLUSTERED ([AccountKey], [AddressKey]) ON [PRIMARY]
GO
