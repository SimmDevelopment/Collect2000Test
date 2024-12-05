CREATE TABLE [dbo].[SRG_ProductToken]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SRG_ProductID] [int] NOT NULL,
[ProcessStatus] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SRG_ProductToken__ProcessStatus] DEFAULT ('Created'),
[StatusDetail] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MostRecentFlag] [bit] NOT NULL CONSTRAINT [DF__SRG_ProductToken__MostRecentFlag] DEFAULT ((1)),
[Token] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TokenOrigin] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Views] [int] NOT NULL CONSTRAINT [DF__SRG_ProductToken__Views] DEFAULT ((0)),
[StatusChanged] [datetime] NOT NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__SRG_ProductToken__Created] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__SRG_ProductToken__CreatedBy] DEFAULT (suser_sname())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductToken] ADD CONSTRAINT [PK_SRG_ProductToken] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductToken_SRG_ProductID] ON [dbo].[SRG_ProductToken] ([SRG_ProductID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductToken] ADD CONSTRAINT [FK_SRG_ProductToken_SRG_Product] FOREIGN KEY ([SRG_ProductID]) REFERENCES [dbo].[SRG_Product] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents a single request for a product.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time this record was created.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user that created this record.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Is this the most recent request for this product for the given accountid/debtorid. 0 ==> no, 1 ==> this is the most recent request. When inserting a record, prevous records for matching product + accountid + debtorid should have this value set to 0.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', 'COLUMN', N'MostRecentFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates the current status of the request. Valid values are: Created,Requested,Pending,Received,Failed,SystemError,Purged . The list of valid values may be expanded.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', 'COLUMN', N'ProcessStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to the SRG_Product table that this record is associated with.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', 'COLUMN', N'SRG_ProductID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time this record last had its status changed.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', 'COLUMN', N'StatusChanged'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A (server supplied) detailed error or status message.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', 'COLUMN', N'StatusDetail'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Value is returned from the SRG when the request is sent. Used to identify the request and then the product on the SRG.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', 'COLUMN', N'Token'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique identifier of the tokenizer database for which this token is valid.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', 'COLUMN', N'TokenOrigin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of times this product was actually retrieved from SRG.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken', 'COLUMN', N'Views'
GO
