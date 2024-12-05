CREATE TABLE [dbo].[Custom_Equabli_EmlPreference_History]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientConsumerNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliConsumerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[emailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[weekDayNo] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[excludedTimeFrom] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[excludedTimeTo] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_EmlPreference_History] ADD CONSTRAINT [PK_Custom_Equabli_EmlPreference_History] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
