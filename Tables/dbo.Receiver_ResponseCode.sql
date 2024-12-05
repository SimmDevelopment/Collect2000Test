CREATE TABLE [dbo].[Receiver_ResponseCode]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClientID] [int] NOT NULL,
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultText] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desk] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QLevel] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_ResponseCode] ADD CONSTRAINT [PK_Receiver_ResponseCode] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO