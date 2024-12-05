CREATE TABLE [dbo].[Receiver_RequestsAndResponses]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClientID] [int] NOT NULL,
[RequestOrigination] [int] NULL,
[AccountID] [int] NOT NULL,
[AgencyID] [int] NOT NULL,
[RequestID] [int] NOT NULL,
[ResponseID] [int] NULL,
[Requested] [datetime] NULL,
[Responded] [datetime] NULL,
[RequestText] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseText] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutsideRequestID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_RequestsAndResponses] ADD CONSTRAINT [PK_Receiver_RequestsAndResponses] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
