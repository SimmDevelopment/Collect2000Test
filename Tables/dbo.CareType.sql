CREATE TABLE [dbo].[CareType]
(
[CareTypeId] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OnHoldDays] [smallint] NOT NULL CONSTRAINT [DF_CareType_OnHoldDays] DEFAULT ((30)),
[Severity] [smallint] NULL,
[ProofRequired] [bit] NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsentRequired] [bit] NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_CareType_CreatedWhen] DEFAULT (getutcdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedWhen] [datetime] NULL CONSTRAINT [DF_CareType_ModifiedWhen] DEFAULT (getutcdate()),
[ModifiedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CareType] ADD CONSTRAINT [PK_CareType] PRIMARY KEY CLUSTERED ([CareTypeId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CareType] ADD CONSTRAINT [UQ_CareType_Code] UNIQUE NONCLUSTERED ([Code]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manages the care types used in the Care and Financial Hardship panel.', 'SCHEMA', N'dbo', 'TABLE', N'CareType', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'CareType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identifier for the care types used in the Care and Financial Hardship panel', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'CareTypeId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Ignore', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'CareTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Varchar code representing the care type. This field is referenced in the CareAndHardship table.', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that specifies whether or not consent is required for the care type.', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'ConsentRequired'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'ConsentRequired'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that identifies who created the initial record.', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that represents the date that the care type record was created.', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that holds a detailed description of the given care type.', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that identifies who last modified the record.', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date field representing the last time a record was modified.', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'ModifiedWhen'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'ModifiedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that represents the default number of On Hold days for the given care type.', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'OnHoldDays'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'OnHoldDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field that represents whether or not proof is required for the given care type.', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'ProofRequired'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'ProofRequired'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that represents the severity of a care type. Values are 1 to 10 with 1 being the most severe.', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'Severity'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CareType', 'COLUMN', N'Severity'
GO
