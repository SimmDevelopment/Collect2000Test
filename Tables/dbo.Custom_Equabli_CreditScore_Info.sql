CREATE TABLE [dbo].[Custom_Equabli_CreditScore_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliConsumerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientConsumerNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[creditscoreSourceType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[creditscoreSourceId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[creditscoreCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateOfScore] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[creditScore] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_CreditScore_Info] ADD CONSTRAINT [PK_Custom_Equabli_CreditScore_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO