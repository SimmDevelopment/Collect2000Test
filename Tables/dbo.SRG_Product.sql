CREATE TABLE [dbo].[SRG_Product]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Parent_SRG_ProductID] [int] NULL,
[QuotaGroup] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PathCode] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModuleName] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PermissionName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SRG_Product__Version] DEFAULT ('0.0.0.0'),
[Active] [bit] NOT NULL CONSTRAINT [DF__SRG_Product__Active] DEFAULT ((1)),
[LeafNode] [bit] NOT NULL CONSTRAINT [DF__SRG_Product__LeafNode] DEFAULT ((0)),
[SRGEnabled] [bit] NOT NULL CONSTRAINT [DF__SRG_Product__SRGEnabled] DEFAULT ((0)),
[Created] [datetime] NOT NULL CONSTRAINT [DF__SRG_Product__Created] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SRG_Product__CreatedBy] DEFAULT (suser_sname()),
[Updated] [datetime] NOT NULL CONSTRAINT [DF__SRG_Product__Updated] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SRG_Product__UpdatedBy] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_Product] ADD CONSTRAINT [PK_SRG_Product] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_Product] ADD CONSTRAINT [FK_SRG_Product_Parent] FOREIGN KEY ([Parent_SRG_ProductID]) REFERENCES [dbo].[SRG_Product] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains products that will have usage tracked and their respective hierarchical non-product parents. Each record can be a leaf node, and may or may not have a parent. Can hold product data that does not utilize the SRG in case where quota is needed. This table is generally maintained by the "SRG Module Installer" except in cases of non "SRGEnabled" records.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Is this product available for use. 0 ==> cannot be used, not valid anymore. 1 ==> good and ready.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time this record was created.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user that created this record.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Textual description of the product. May be used for mouseover event display.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name that is displayed for user selection in a dropdown control on a user interface.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'DisplayName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This product is not a parent to any other products. Indicates that the DisplayName value is suitable for displaying in a dropdown after the parent is selected (See Parent_SRG_ProductID).', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'LeafNode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'See permission table. Each product may have a permission associated with it. This is required so that code can dynamically determine which permissions apply to this product. See SRG_ProductConfig table.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'ModuleName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The parent id if this product has a parent. A leaf node will generally have a parent. For example: A record for the product "full credit report" will have a parent that would be "Trans Union" (in this case the parent is the vendor).', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'Parent_SRG_ProductID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The identifying string that identifies this product on Latitude Service Request Gateway. It is a well known value that is supplied by the module on the SRG.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'PathCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'See permission table. Each product may have a permission associated with it. This is required so that code can dynamically determine which permissions apply to this product. See SRG_ProductConfig table.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'PermissionName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A value that specifies what group this product is covered by in the SRG_ProductQuotaPeriod table. For example: The "TransUnion"."Full Credit Report" would have a value of "CBRT", and also all credit report products would have this same value. This value determines the SRG_ProductQuotaPeriod record that applies. If blank or null then quota is not valid for product record.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'QuotaGroup'
GO
EXEC sp_addextendedproperty N'MS_Description', N' If the value is 1 then this record was added and is maintained by the "SRG Module Installer" application. If the value is 0 then this record is not maintained by the "SRG Module Installer" application.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'SRGEnabled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date this record was most recently updated.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'Updated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user that most recently updated this record.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'UpdatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The version number of the installed module. Defaults to 0.0.0.0.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_Product', 'COLUMN', N'Version'
GO
