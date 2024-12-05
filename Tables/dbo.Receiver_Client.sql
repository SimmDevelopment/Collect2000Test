CREATE TABLE [dbo].[Receiver_Client]
(
[ClientId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Configuration] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgencyId] [int] NULL,
[DemPayEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DemPaySendNotification] [bit] NULL,
[FileDirectory] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AlphaCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UsingAlphaCode] [bit] NULL,
[ClientOnOlderVersion] [bit] NULL CONSTRAINT [DF__Receiver___Clien__73C08B3B] DEFAULT ((0)),
[CheckForEchoBacks] [bit] NULL CONSTRAINT [DF__Receiver___Check__75A8D3AD] DEFAULT ((0)),
[DateColumnForEchoBackFlags] [int] NULL,
[DaysPriorForEchoBack] [int] NULL,
[AIMClientVersion] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendOverpaidAmount] [bit] NULL CONSTRAINT [DF_Receiver_Client_SendOverpaidAmount] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_Client] ADD CONSTRAINT [PK_AIM_ReceiverClient] PRIMARY KEY CLUSTERED ([ClientId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
