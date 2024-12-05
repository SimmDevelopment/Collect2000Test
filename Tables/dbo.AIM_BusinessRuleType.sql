CREATE TABLE [dbo].[AIM_BusinessRuleType]
(
[BusinessRuleTypeId] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_BusinessRuleType] ADD CONSTRAINT [PK_BusinessRuleType] PRIMARY KEY CLUSTERED ([BusinessRuleTypeId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRuleType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRuleType', 'COLUMN', N'BusinessRuleTypeId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRuleType', 'COLUMN', N'BusinessRuleTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRuleType', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRuleType', 'COLUMN', N'Name'
GO
