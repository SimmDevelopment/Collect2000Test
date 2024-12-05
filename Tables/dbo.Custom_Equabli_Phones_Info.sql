CREATE TABLE [dbo].[Custom_Equabli_Phones_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientConsumerNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliConsumerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phoneNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phoneType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[wirelessIndicator] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isPrimary] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[doNotCallFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[consentFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[consentDateTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phoneStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phoneUpdateDateTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[smsConsentFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[smsConsentDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[externalSystemId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Phones_Info] ADD CONSTRAINT [PK_Custom_Equabli_Phones_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
