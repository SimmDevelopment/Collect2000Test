CREATE TABLE [dbo].[AIM_ObjectionReason]
(
[ObjectionReasonId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Code] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtensionNumDays] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_ObjectionReason] ADD CONSTRAINT [PK_ObjectionReason] PRIMARY KEY CLUSTERED ([ObjectionReasonId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'AIM_ObjectionReason', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined code for the objection', 'SCHEMA', N'dbo', 'TABLE', N'AIM_ObjectionReason', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_ObjectionReason', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'number of days to advance final recall when processing this objection', 'SCHEMA', N'dbo', 'TABLE', N'AIM_ObjectionReason', 'COLUMN', N'ExtensionNumDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_ObjectionReason', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_ObjectionReason', 'COLUMN', N'ObjectionReasonId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_ObjectionReason', 'COLUMN', N'ObjectionReasonId'
GO
