CREATE TABLE [dbo].[Receiver_Dispute]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Source] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountID] [int] NOT NULL,
[ClientID] [int] NOT NULL,
[DisputeID] [int] NULL,
[AIMDisputeID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_Dispute] ADD CONSTRAINT [PK_Receiver_Dispute] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
