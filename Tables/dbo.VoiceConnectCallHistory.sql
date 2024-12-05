CREATE TABLE [dbo].[VoiceConnectCallHistory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Guid] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_VoiceConnectCallHistory_Guid] DEFAULT (newid()),
[ImportDate] [datetime] NULL,
[CallTime] [datetime] NULL,
[Result] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seconds] [int] NULL,
[Charge] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[VoiceConnectCallHistory] ADD CONSTRAINT [PK_VoiceConnectCallHistory] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
