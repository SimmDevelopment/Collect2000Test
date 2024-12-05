CREATE TABLE [dbo].[Attunely_ContactPhones]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhoneKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PhoneNumber] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Party_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPartyDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndpointType_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL,
[Deleted] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_ContactPhones] ADD CONSTRAINT [PK_Attunely_ContactPhones] PRIMARY KEY CLUSTERED ([AccountKey], [PhoneKey]) ON [PRIMARY]
GO
