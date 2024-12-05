CREATE TABLE [dbo].[Attunely_ContactEmails]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmailKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Party_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPartyDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EndpointType_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL,
[Deleted] [datetime2] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_ContactEmails] ADD CONSTRAINT [PK_Attunely_ContactEmails] PRIMARY KEY CLUSTERED ([AccountKey], [EmailKey]) ON [PRIMARY]
GO
