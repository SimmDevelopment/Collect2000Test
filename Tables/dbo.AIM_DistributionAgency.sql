CREATE TABLE [dbo].[AIM_DistributionAgency]
(
[DistributionAgencyId] [int] NOT NULL IDENTITY(1, 1),
[DistributionTemplateId] [int] NULL,
[AgencyId] [int] NULL,
[DistributionPercentage] [float] NULL,
[CommissionPercentage] [float] NULL,
[AgencyOrder] [int] NULL,
[FeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecallDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_DistributionAgency] ADD CONSTRAINT [PK_DistributionAgency] PRIMARY KEY CLUSTERED ([DistributionAgencyId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_DistributionAgency] ADD CONSTRAINT [AIM_FK_DistributionAgency_Agency] FOREIGN KEY ([AgencyId]) REFERENCES [dbo].[AIM_Agency] ([AgencyId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AIM_DistributionAgency] ADD CONSTRAINT [AIM_FK_DistributionAgency_DistributionTemplate] FOREIGN KEY ([DistributionTemplateId]) REFERENCES [dbo].[AIM_DistributionTemplate] ([DistributionTemplateId]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'the agency associated with this distribution template', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionAgency', 'COLUMN', N'AgencyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the order in which to place accounts', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionAgency', 'COLUMN', N'AgencyOrder'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the commission percentage for this agency for this template', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionAgency', 'COLUMN', N'CommissionPercentage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionAgency', 'COLUMN', N'DistributionAgencyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the percentage for this agency for this template', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionAgency', 'COLUMN', N'DistributionPercentage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the template id for this distribution', 'SCHEMA', N'dbo', 'TABLE', N'AIM_DistributionAgency', 'COLUMN', N'DistributionTemplateId'
GO
