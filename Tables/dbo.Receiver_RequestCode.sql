CREATE TABLE [dbo].[Receiver_RequestCode]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClientID] [int] NOT NULL,
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultText] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desk] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QLevel] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequiresResponse] [bit] NULL CONSTRAINT [DF__Receiver___Requi__7B61AD03] DEFAULT ((0)),
[ResponseDays] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_RequestCode] ADD CONSTRAINT [PK_Receiver_RequestCode] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
