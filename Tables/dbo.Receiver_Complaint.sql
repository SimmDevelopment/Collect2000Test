CREATE TABLE [dbo].[Receiver_Complaint]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Source] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountID] [int] NOT NULL,
[ClientID] [int] NOT NULL,
[ComplaintID] [int] NULL,
[AIMComplaintID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_Complaint] ADD CONSTRAINT [PK_Receiver_Complaint] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
