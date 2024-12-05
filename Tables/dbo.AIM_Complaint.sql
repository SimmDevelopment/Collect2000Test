CREATE TABLE [dbo].[AIM_Complaint]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Source] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountID] [int] NOT NULL,
[AgencyID] [int] NOT NULL,
[ComplaintID] [int] NULL,
[ReceiverComplaintID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Complaint] ADD CONSTRAINT [PK_AIM_Complaint] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
