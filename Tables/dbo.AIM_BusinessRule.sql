CREATE TABLE [dbo].[AIM_BusinessRule]
(
[BusinessRuleId] [int] NOT NULL IDENTITY(1, 1),
[BusinessRuleTypeId] [int] NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [bit] NULL,
[Frequency] [int] NULL,
[FrequencyType] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountFilterId] [int] NULL,
[DistributionTemplateId] [int] NULL,
[ScheduleId] [int] NULL,
[EmailAddresses] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_BusinessRule] ADD CONSTRAINT [PK_BusinessRule] PRIMARY KEY CLUSTERED ([BusinessRuleId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_BusinessRule] ADD CONSTRAINT [IX_BusinessRule] UNIQUE NONCLUSTERED ([Name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_BusinessRule] ADD CONSTRAINT [AIM_FK_BusinessRule_AccountFilter] FOREIGN KEY ([AccountFilterId]) REFERENCES [dbo].[AIM_AccountFilter] ([AccountFilterId]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[AIM_BusinessRule] ADD CONSTRAINT [AIM_FK_BusinessRule_BusinessRuleType] FOREIGN KEY ([BusinessRuleTypeId]) REFERENCES [dbo].[AIM_BusinessRuleType] ([BusinessRuleTypeId])
GO
ALTER TABLE [dbo].[AIM_BusinessRule] ADD CONSTRAINT [AIM_FK_BusinessRule_DistributionTemplate] FOREIGN KEY ([DistributionTemplateId]) REFERENCES [dbo].[AIM_DistributionTemplate] ([DistributionTemplateId]) ON UPDATE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated account filter for this business rule', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRule', 'COLUMN', N'AccountFilterId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRule', 'COLUMN', N'BusinessRuleId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type ID for this business rule', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRule', 'COLUMN', N'BusinessRuleTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated distribution template for this business fule', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRule', 'COLUMN', N'DistributionTemplateId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'email to send to upon completion', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRule', 'COLUMN', N'EmailAddresses'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag for if the business rule is enabled', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRule', 'COLUMN', N'Enabled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The frequency of this business rule', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRule', 'COLUMN', N'Frequency'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The type of frequency for this business rule', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRule', 'COLUMN', N'FrequencyType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the business rule', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRule', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the scheduleid of this business rule', 'SCHEMA', N'dbo', 'TABLE', N'AIM_BusinessRule', 'COLUMN', N'ScheduleId'
GO
