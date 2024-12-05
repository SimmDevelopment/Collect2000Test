CREATE TABLE [dbo].[Custom_Equabli_CommunicationHistory_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientConsumerNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliConsumerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[communicationId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[communicationChannel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[communicationReason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[communicationSubreason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[communicationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[communicationTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[communicationOutcome] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[communicationDirection] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[communicationDisposition] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[communicationDetails] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[discountPercentage] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rpcReceivedFlag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rpcReceivedDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[complianceType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[complianceSubType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[complianceDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[complianceId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateCommunicationUpdate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[communicationUpdateTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[regulatoryBody] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[commentRemark] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_CommunicationHistory_Info] ADD CONSTRAINT [PK_Custom_Equabli_CommunicationHistory_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
