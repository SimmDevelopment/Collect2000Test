CREATE TABLE [dbo].[CreditCardTypes]
(
[Code] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DESCRIPTION] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValidationPattern] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cvv2Location] [bit] NULL,
[ChecksumAlgorithm] [tinyint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CreditCardTypes] ADD CONSTRAINT [pk_CreditCardTypes] PRIMARY KEY NONCLUSTERED ([Code]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Defines Creditcard Types Available or Used.', 'SCHEMA', N'dbo', 'TABLE', N'CreditCardTypes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Checksum algorithm used to validate card number', 'SCHEMA', N'dbo', 'TABLE', N'CreditCardTypes', 'COLUMN', N'ChecksumAlgorithm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Internal code for credit card', 'SCHEMA', N'dbo', 'TABLE', N'CreditCardTypes', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location of the security code on the creditcard', 'SCHEMA', N'dbo', 'TABLE', N'CreditCardTypes', 'COLUMN', N'Cvv2Location'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of credit card', 'SCHEMA', N'dbo', 'TABLE', N'CreditCardTypes', 'COLUMN', N'DESCRIPTION'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Regex expression used to validate credit card pattern and automatically credit card type', 'SCHEMA', N'dbo', 'TABLE', N'CreditCardTypes', 'COLUMN', N'ValidationPattern'
GO
