CREATE TABLE [dbo].[BIN_List]
(
[BIN] [int] NOT NULL,
[Brand] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BankName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Level] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ISOCountry] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Info] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country_ISO] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country2_ISO] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country3_ISO] [int] NULL,
[WWW] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BIN_List] ADD CONSTRAINT [PK_BIN_List] PRIMARY KEY CLUSTERED ([BIN]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the bank or financial institution which issued the card.', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'BankName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The first six digits of a card number are known as the issuer identification number (IIN) aka Bank Identification Number (BIN)', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'BIN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Card brand specifies the card company/vendor which issued the card� i.e. Visa/MasterCard/AMEX etc.', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'Brand'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Two letter ISO country code.', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'Country_ISO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Three letter ISO country code.', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'Country2_ISO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numeric ISO country code.', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'Country3_ISO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Additional information if available. Usually contact or alternative contact information about the issuing bank.', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'Info'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Full name of the country of origin e.g. "United States"', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'ISOCountry'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The level field specifies of a card is PREPAID/GOLD/GIFT/BUSINESS/ELECTRON etc.', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'Level'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact phone number of the issuing bank. Usually the main branch phone.', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of card. i.e. CREDIT/DEBIT', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'URL Address of the issuing bank main website.', 'SCHEMA', N'dbo', 'TABLE', N'BIN_List', 'COLUMN', N'WWW'
GO
