CREATE TABLE [dbo].[Custom_Equabli_Email_Inbound_History]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientConsumerNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliConsumerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[emailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[emailWorkFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[optoutFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[emailValidityFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[consentFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[consentDateTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[statusCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isPrimary] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateUpdated] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Email_Inbound_History] ADD CONSTRAINT [PK_Custom_Equabli_Email_Inbound_History] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
