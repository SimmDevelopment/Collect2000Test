CREATE TABLE [dbo].[letter]
(
[code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutsideService] [real] NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[documentname] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[allowclosed] [bit] NOT NULL CONSTRAINT [DF_letter_allowclosed] DEFAULT (0),
[allowcollector] [bit] NOT NULL CONSTRAINT [DF_letter_allowcollector] DEFAULT (0),
[allowoutside] [bit] NOT NULL CONSTRAINT [DF_letter_allowoutside] DEFAULT (0),
[allowzero] [bit] NOT NULL CONSTRAINT [DF_letter_allowzero] DEFAULT (0),
[fee] [money] NULL,
[DocData] [image] NULL,
[type] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllowFirst30] [bit] NULL,
[AllowAfter30] [bit] NULL,
[CopyCustomer] [bit] NOT NULL CONSTRAINT [DF_letter_CopyCustomer] DEFAULT (0),
[SaveImage] [bit] NOT NULL CONSTRAINT [DF_letter_SaveImage] DEFAULT (0),
[LetterID] [int] NOT NULL IDENTITY(1, 1),
[EmailSubject] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_letter_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_letter_DateUpdated] DEFAULT (getdate()),
[vendorLetter] [bit] NOT NULL CONSTRAINT [DF__letter__vendorLe__05BA7BDB] DEFAULT (0),
[linkedLetter] [bit] NOT NULL CONSTRAINT [def_letter_linkedLetter] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[letter] ADD CONSTRAINT [PK_letter] PRIMARY KEY CLUSTERED ([LetterID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_letter_code] ON [dbo].[letter] ([code]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [letter1] ON [dbo].[letter] ([code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[letter] ADD CONSTRAINT [FK_Letter_LetterType] FOREIGN KEY ([type]) REFERENCES [dbo].[LetterType] ([Code])
GO
EXEC sp_addextendedproperty N'MS_Description', N'The letters table is used to create letter templates', 'SCHEMA', N'dbo', 'TABLE', N'letter', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set retstricts the letter to be sent to accounts only after the the agency has held the account for 30 days.', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'AllowAfter30'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set allows letter to be sent to closed accounts.', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'allowclosed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set retstricts the letter to be sent to accounts within the first 30 days of the agency holding the account.', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'AllowFirst30'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set allows letter to be sent to accounts having no outstanding balance.', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'allowzero'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined unique letter code.  Several default are provided:', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set copies Customer on letter', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'CopyCustomer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Creation datetimestamp', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Update datetimestamp', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of letter', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Document image of letter template. ', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'DocData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Filename of template stored in DocData', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'documentname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Subject line of Email message for respective letter.', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'EmailSubject'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity ID', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'LetterID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If indicator set and the letter requests are output to a vendor file, all open accounts linked to the account will be included.', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'linkedLetter'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set allows letter image to be retained for printed letters.  Images are retained in the Documentation and Documentation_Attachment tables. NOTE: Images will only be saved for letters printed in house (not when created for a letter file).  ', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'SaveImage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type code of Letter:  Dunning - DUN, Settlement - SIF, Payoff - PIF, Payment Reminder - PPA, Multipart Settlement - PPS, NITD - PPC, Customer - CUS, Attorney - ATT', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set will allow letter to be sent to outside Vendor for processing.', 'SCHEMA', N'dbo', 'TABLE', N'letter', 'COLUMN', N'vendorLetter'
GO
