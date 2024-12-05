CREATE TABLE [dbo].[cbr_config]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[enabled] [bit] NOT NULL,
[InnovisID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EquifaxID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExperianID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransUnionID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReporterName] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReporterAddress] [varchar] (96) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReporterPhone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BaseIdNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[lastEvaluated] [datetime] NULL,
[IndustryCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__cbr_config__IndustryCode] DEFAULT ('DEBTCOLL'),
[CbrInitialize] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_config] ADD CONSTRAINT [PK_cbr_config] PRIMARY KEY CLUSTERED ([id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary configuration table for credit reporting.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Identification Number is an internal identifier used by your agency, and may not be necessary (each credit bureau has a unique number that will be assigned to your agency).  Internal numbers may indicate a branch, office or credit central where information is verified. ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', 'COLUMN', N'BaseIdNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A value of T will cause the credit reporting evaluation to regenerate previously or initially reported paid in fulls and or deletes.  Primarily for implementation use, can also be used to allow previously reported paid in full accounts to be deleteed from the bureaus.  Custom customer option which they use at their own risk . System level configuration.  Only On or Off for all customers', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', 'COLUMN', N'CbrInitialize'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Switch that globally enables or disables credit reporting for all customers.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', 'COLUMN', N'enabled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency specific ID for reporting to Equifax', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', 'COLUMN', N'EquifaxID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency specific ID for reporting to Experian', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', 'COLUMN', N'ExperianID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', 'COLUMN', N'id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency specific ID for reporting to Innovis', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', 'COLUMN', N'InnovisID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Address', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', 'COLUMN', N'ReporterAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Name', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', 'COLUMN', N'ReporterName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency Phone', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', 'COLUMN', N'ReporterPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agency specific ID for reporting to TransUnion', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config', 'COLUMN', N'TransUnionID'
GO
