CREATE TABLE [dbo].[Custom_Equabli_OpRequest_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientConsumerNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliConsumerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[requestNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[requestType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[queueReasonCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[requestSource] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[requestSourceId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[requestDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fulfillmentDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[requestStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_OpRequest_Info] ADD CONSTRAINT [PK_Custom_Equabli_OpRequest_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
