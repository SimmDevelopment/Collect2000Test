CREATE TABLE [dbo].[CourtCaseStatus]
(
[ID] [tinyint] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CourtCaseStatus] ADD CONSTRAINT [PK_CourtCaseStatus] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CourtCaseStatus_Code] ON [dbo].[CourtCaseStatus] ([Code]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reference table to hold the valid court case statuses.', 'SCHEMA', N'dbo', 'TABLE', N'CourtCaseStatus', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'CourtCaseStatus', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'A code to use for the court case status, this is unique and will be used in the CourtCases.Status field.', 'SCHEMA', N'dbo', 'TABLE', N'CourtCaseStatus', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'CourtCaseStatus', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The description of the court case status, we will ship the previous X court case statuses that were available in the drop down, this value will contain what was in the drop down', 'SCHEMA', N'dbo', 'TABLE', N'CourtCaseStatus', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CourtCaseStatus', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique id of the court case status.', 'SCHEMA', N'dbo', 'TABLE', N'CourtCaseStatus', 'COLUMN', N'ID'
GO
