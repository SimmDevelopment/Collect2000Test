CREATE TABLE [dbo].[Custom_Equabli_ChangeLog_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[entityShortName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attributeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[externalSourceType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[externalSourceId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[externalSystemId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[previousValue] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[newValue] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientConsumerNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliConsumerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_ChangeLog_Info] ADD CONSTRAINT [PK_Custom_Equabli_ChangeLog_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
