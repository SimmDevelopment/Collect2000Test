CREATE TABLE [dbo].[Insurance]
(
[InsuranceId] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NOT NULL,
[InsuredName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuredStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuredStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuredCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuredState] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuredZip] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuredPhone] [char] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuredBirthday] [datetime] NULL,
[InsuredSex] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuredEmployer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthPmtToProvidor] [bit] NOT NULL CONSTRAINT [DF__Insurance__AuthP__729CBA6F] DEFAULT (0),
[AcceptAssignment] [bit] NOT NULL CONSTRAINT [DF__Insurance__Accep__7390DEA8] DEFAULT (0),
[EmployerHealthPlan] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PolicyNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientRelationToInsured] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierState] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierZip] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierDocProviderNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CarrierRefDocProviderNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdditionalInfo] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NOT NULL,
[DateUpdated] [datetime] NOT NULL,
[UpdateChecksum] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [int] NOT NULL,
[CoordinationNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuredWorkPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsuredSSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Insurance] ADD CONSTRAINT [PK_Insurance] PRIMARY KEY CLUSTERED ([InsuranceId]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Insurance_Number] ON [dbo].[Insurance] ([Number]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Insurance] WITH NOCHECK ADD CONSTRAINT [FK_Insurance_master] FOREIGN KEY ([Number]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used to store basic Insurance policy and provider information. Multiple rows of information may be kept for each account.', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Additional comments', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'AdditionalInfo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Carrier city', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'CarrierCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Health plan Carrier name.', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'CarrierName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Carrier state', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'CarrierState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Carrier address line 1', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'CarrierStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Carrier address line 2', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'CarrierStreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Carrier zipcode', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'CarrierZip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Creation datetimestamp', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Update datetimestamp', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Health plan ID or Name', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'EmployerHealthPlan'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Health plan group name', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'GroupName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Health plan Group number', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'GroupNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity ID', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'InsuranceId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of birh of policy holder', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'InsuredBirthday'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City of policy holder', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'InsuredCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employer information of policy holder', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'InsuredEmployer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Full name of Insured policy holder', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'InsuredName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone number of policy holder', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'InsuredPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Gender of policy holder', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'InsuredSex'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State of policy holder', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'InsuredState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 1 of policy holder', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'InsuredStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 2 of policy holder', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'InsuredStreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Zipcode of policy holder', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'InsuredZip'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relationship of patirnt to insured', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'PatientRelationToInsured'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Policy number of health plan', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'PolicyNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Health plan program ID', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'Program'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Internal use only', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'UpdateChecksum'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude User ID performing update', 'SCHEMA', N'dbo', 'TABLE', N'Insurance', 'COLUMN', N'UpdatedBy'
GO
