CREATE TABLE [dbo].[WorkFlow_Distribution_DistributionHistory]
(
[WorkFlow_Distribution_DistributionHistoryID] [bigint] NOT NULL IDENTITY(1, 1),
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountID] [int] NOT NULL,
[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_Distribution_DistributionHistory] ADD CONSTRAINT [pk_WorkFlow_Distribution_DistributionHistory] PRIMARY KEY CLUSTERED ([WorkFlow_Distribution_DistributionHistoryID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [uq_Desk_AccountID_Date] ON [dbo].[WorkFlow_Distribution_DistributionHistory] ([Desk], [AccountID], [Date]) ON [PRIMARY]
GO
