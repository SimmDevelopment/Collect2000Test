CREATE TABLE [dbo].[Custom_Equabli_Address_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientConsumerNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliConsumerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressUpdateDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isPrimaryAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isVerified] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[externalSystemId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Address_Info] ADD CONSTRAINT [PK_Custom_Equabli_Address_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
