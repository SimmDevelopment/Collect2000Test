CREATE TABLE [dbo].[cbr_config_customer]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[CustomerId] [int] NULL,
[cbr_config_id] [int] NOT NULL,
[Created] [datetime] NOT NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF__cbr_confi__Enabl__261700DE] DEFAULT ((1)),
[Updated] [datetime] NOT NULL,
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_config_customer] ADD CONSTRAINT [PK_cbr_config_customer] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_config_customer] ADD CONSTRAINT [FK_cbr_config_customer_cbr_config] FOREIGN KEY ([cbr_config_id]) REFERENCES [dbo].[cbr_config] ([id])
GO
ALTER TABLE [dbo].[cbr_config_customer] ADD CONSTRAINT [FK_cbr_config_customer_customer] FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CCustomerID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Associates the cbr_config table and customer table. Records should not get deleted (only disabled). This table also serves as an audit of when and by who customers were added and removed from cbr setup configuration records.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config_customer', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to the cbr_config table. Relates the cbr_config record to use for header of credit reporting file.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config_customer', 'COLUMN', N'cbr_config_id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When was this record inserted?', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config_customer', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude user that created this record.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config_customer', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Customer.CCustomerID value. If this is null, then it is the default record for all other customers.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config_customer', 'COLUMN', N'CustomerId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Is this record valid (0 = False)? If Enabled is False then it is only valuable for auditing changes. Enabled value should never be updated back to True (1 = True), instead insert a new record.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config_customer', 'COLUMN', N'Enabled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identity value.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config_customer', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When was this record last updated (inserted or disabled). The Enabled flag is the only value that should be updated. Should set Enabled = False instead of deleting the record. Insert a new record in lieu of setting Enabled = True.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config_customer', 'COLUMN', N'Updated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude user that inserted or disabled this record.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_config_customer', 'COLUMN', N'UpdatedBy'
GO
