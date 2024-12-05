CREATE TABLE [dbo].[DisputeType]
(
[DisputeTypeId] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProofRequired] [bit] NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_DisputeType_CreatedWhen] DEFAULT (getutcdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedWhen] [datetime] NULL CONSTRAINT [DF_DisputeType_ModifiedWhen] DEFAULT (getutcdate()),
[ModifiedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DisputeType] ADD CONSTRAINT [PK_DisputeType] PRIMARY KEY CLUSTERED ([DisputeTypeId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DisputeType] ADD CONSTRAINT [UQ_DisputeType_Code] UNIQUE NONCLUSTERED ([Code]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manages the dispute types used in the disputes panel.', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'True', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Varchar code representing the dispute type. This field is referenced in the Dispute table.', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that identifies who created the initial record.', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that represents the date that the dispute type record was created.', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that holds a detailed description of the given dispute type.', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identifier for the dispute types used in the Disputes panel', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'DisputeTypeId'
GO
EXEC sp_addextendedproperty N'Snychronize', N'Ignore', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'DisputeTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that identifies who last modified the record.', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date field representing the last time a record was modified.', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'ModifiedWhen'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'ModifiedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bit field that represents whether or not proof is required for the given dispute type.', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'ProofRequired'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'DisputeType', 'COLUMN', N'ProofRequired'
GO
