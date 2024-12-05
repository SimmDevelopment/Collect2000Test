CREATE TABLE [dbo].[AIM_DistributionTemplate]
(
[DistributionTemplateId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AutoRecallOn] [bit] NULL,
[PreRecallNoticeDays] [int] NULL,
[RecallNoticeDays] [int] NULL,
[DistributionType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[assignlinkedaccountstosameagency] [bit] NULL CONSTRAINT [DF__AIM_Distr__assig__6BFF6DE2] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_DistributionTemplate] ADD CONSTRAINT [PK_DistributionTemplate] PRIMARY KEY CLUSTERED ([DistributionTemplateId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_DistributionTemplate] ADD CONSTRAINT [IX_DistributionTemplate] UNIQUE NONCLUSTERED ([Name]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag for auto recall', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionTemplate', 'COLUMN', N'AutoRecallOn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionTemplate', 'COLUMN', N'DistributionTemplateId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'type of distribution', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionTemplate', 'COLUMN', N'DistributionType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionTemplate', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'days for notification', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionTemplate', 'COLUMN', N'PreRecallNoticeDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'days for notification', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionTemplate', 'COLUMN', N'RecallNoticeDays'
GO
