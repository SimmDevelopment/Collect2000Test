CREATE TABLE [dbo].[AIM_Dispute]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Source] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountID] [int] NOT NULL,
[AgencyID] [int] NOT NULL,
[DisputeID] [int] NULL,
[ReceiverDisputeID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Dispute] ADD CONSTRAINT [PK_AIM_Dispute] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
