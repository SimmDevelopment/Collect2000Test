CREATE TABLE [dbo].[SRG_ProductTokenAudit]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SRG_ProductTokenId] [int] NOT NULL,
[ColumnName] [sys].[sysname] NOT NULL,
[Comment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OldValue] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewValue] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__SRG_ProductTokenAudit__Created] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SRG_ProductTokenAudit__CreatedBy] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductTokenAudit] ADD CONSTRAINT [PK_SRG_ProductTokenAudit] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductTokenAudit_SRG_ProductTokenID] ON [dbo].[SRG_ProductTokenAudit] ([SRG_ProductTokenId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductTokenAudit] ADD CONSTRAINT [FK_SRG_ProductTokenAudit_SRG_ProductToken] FOREIGN KEY ([SRG_ProductTokenId]) REFERENCES [dbo].[SRG_ProductToken] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents a change to a value in the SRG_ProductToken record.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductTokenAudit', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the column who''s value changed in the SRG_ProductToken table. Normal values are ProcessStatus, Views, and MostRecentFlag.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductTokenAudit', 'COLUMN', N'ColumnName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Any additional information for the change. For example some descriptive message if status changed to Error or Failed.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductTokenAudit', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time this record was created.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductTokenAudit', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user that created this record.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductTokenAudit', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductTokenAudit', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Changed to value.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductTokenAudit', 'COLUMN', N'NewValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Changed from value.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductTokenAudit', 'COLUMN', N'OldValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to the SRG_ProductToken table that this record is associated with.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductTokenAudit', 'COLUMN', N'SRG_ProductTokenId'
GO
