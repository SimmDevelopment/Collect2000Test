CREATE TABLE [dbo].[LMSE_ActionHistory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ActionID] [uniqueidentifier] NOT NULL,
[BatchID] [uniqueidentifier] NOT NULL,
[UserID] [int] NOT NULL,
[Completed] [datetime] NULL,
[RecordCount] [int] NULL,
[AppliedConfiguration] [xml] NULL,
[Started] [datetime] NULL,
[ActionName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LMSE_ActionHistory] ADD CONSTRAINT [PK__LMSE_Act__3214EC275C979F60] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table retains information about Actions that were performed using the LatitudeMangagementSuiteExtensionWizard ', 'SCHEMA', N'dbo', 'TABLE', N'LMSE_ActionHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID of the Action that was performed ', 'SCHEMA', N'dbo', 'TABLE', N'LMSE_ActionHistory', 'COLUMN', N'ActionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Name of the Action which was performed ', 'SCHEMA', N'dbo', 'TABLE', N'LMSE_ActionHistory', 'COLUMN', N'ActionName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The XML configuration for the options that were selected when performing the Action ', 'SCHEMA', N'dbo', 'TABLE', N'LMSE_ActionHistory', 'COLUMN', N'AppliedConfiguration'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID of the Batch that was assigned to the executed Action ', 'SCHEMA', N'dbo', 'TABLE', N'LMSE_ActionHistory', 'COLUMN', N'BatchID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The DateTime at which the Action completed ', 'SCHEMA', N'dbo', 'TABLE', N'LMSE_ActionHistory', 'COLUMN', N'Completed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity key', 'SCHEMA', N'dbo', 'TABLE', N'LMSE_ActionHistory', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The total number of records the Action affected ', 'SCHEMA', N'dbo', 'TABLE', N'LMSE_ActionHistory', 'COLUMN', N'RecordCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The DateTime at which the Action started', 'SCHEMA', N'dbo', 'TABLE', N'LMSE_ActionHistory', 'COLUMN', N'Started'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID of the User that executed Action ', 'SCHEMA', N'dbo', 'TABLE', N'LMSE_ActionHistory', 'COLUMN', N'UserID'
GO
