CREATE TABLE [dbo].[PaymentVendorToken]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Token] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TokenUpdated] [datetime] NOT NULL,
[Hash] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TokenOrigin] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MaskedValue] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PayMethodId] [int] NOT NULL,
[PayMethodCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PayMethodSubTypeCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastResult] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastResultDate] [datetime] NULL,
[Created] [datetime] NOT NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentVendorToken] ADD CONSTRAINT [PK_PaymentVendorToken] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents a token that is returned from the Latitude Payment Vendor Gateway when a payment device is authorized.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'When was this record inserted?', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude user that created this record.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A hash value that represents a payment device.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identity value.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The last result value when using this Token during a Latitude Payment Vendor Gateway request.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'LastResult'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The datetime of the LastResult.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'LastResultDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Masked payment device account number value. Generally just last 4 digits.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'MaskedValue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A code for the payment device. Generally from pmethod.paymethod.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'PayMethodCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Value that matches the pmethod.id value for the payment device.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'PayMethodId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Misc information. Values depend on the paymethod.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'PayMethodSubTypeCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Token returned from Latitude Tokenizer upon payment device authorization. Used when submitting a transaction request to Latitude Payment Vendor Gateway.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'Token'
GO
EXEC sp_addextendedproperty N'MS_Description', N'What information was used when the Token value was last updated. Format is "VendorCode : Info1 : Info2"', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'TokenOrigin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime that the Token value was last updated. The token value can possibly change after a transaction.', 'SCHEMA', N'dbo', 'TABLE', N'PaymentVendorToken', 'COLUMN', N'TokenUpdated'
GO
