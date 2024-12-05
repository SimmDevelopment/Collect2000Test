CREATE TABLE [dbo].[AgencyGroupAssignments]
(
[GroupCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AgencyCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AllocationPercent] [real] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyGroupAssignments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyGroupAssignments', 'COLUMN', N'AgencyCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyGroupAssignments', 'COLUMN', N'AllocationPercent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyGroupAssignments', 'COLUMN', N'GroupCode'
GO
