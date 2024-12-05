CREATE TABLE [dbo].[SRG_ProductConfig]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SRG_ProductID] [int] NOT NULL,
[PolicyCodeName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__SRG_ProductConfig__Created] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SRG_ProductConfig__CreatedBy] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductConfig] ADD CONSTRAINT [PK_SRG_ProductConfig] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductConfig_SRG_ProductID] ON [dbo].[SRG_ProductConfig] ([SRG_ProductID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductConfig] ADD CONSTRAINT [FK_SRG_ProductConfig_SRG_Product] FOREIGN KEY ([SRG_ProductID]) REFERENCES [dbo].[SRG_Product] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Child records to the SRG_Product table. Records are inserted and maintained by the SRG Module Installer. Defines particular policy values for a product (See SRG_Product.ModuleName and SRG_Product.PermissionName).', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductConfig', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time this record was created.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductConfig', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user that created this record.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductConfig', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates the datatype of the data identified by this record. Valid values are: String; Date; Integer; Long; Float; Decimal; Binary; Boolean. A Binary type is a byte array.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductConfig', 'COLUMN', N'DataType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductConfig', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Value to identify a particular policy that applies to the parent product.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductConfig', 'COLUMN', N'PolicyCodeName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to the SRG_Product table that this record is associated with.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductConfig', 'COLUMN', N'SRG_ProductID'
GO
