CREATE TABLE [dbo].[FinancialHardship]
(
[FinancialHardshipId] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProofRequired] [bit] NULL,
[OnHoldDays] [smallint] NOT NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_FinancialHardship_CreatedWhen] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedWhen] [datetime] NULL CONSTRAINT [DF_FinancialHardship_ModifiedWhen] DEFAULT (getdate()),
[ModifiedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FinancialHardship] ADD CONSTRAINT [PK_FinancialHardship] PRIMARY KEY CLUSTERED ([FinancialHardshipId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FinancialHardship] ADD CONSTRAINT [UQ_FinancialHardship_Code] UNIQUE NONCLUSTERED ([Code]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manages the financial hardship types used in the Care and Financial Hardship panel.', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Varchar code representing the financial hardship type. This field is referenced in the CareAndHardship table.', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that identifies who created the initial record.', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that represents the date that the care type record was created.', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that holds a detailed description of the given financial hardship type.', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identifier for the financial hardship types used in the Care and Financial Hardship panel', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'FinancialHardshipId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Ignore', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'FinancialHardshipId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that identifies who last modified the record.', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date field representing the last time a record was modified.', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'ModifiedWhen'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'ModifiedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that represents the default number of On Hold days for the given financial hardship type.', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'OnHoldDays'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'OnHoldDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field that represents whether or not proof is required for the given financial hardship type.', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'ProofRequired'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'FinancialHardship', 'COLUMN', N'ProofRequired'
GO
