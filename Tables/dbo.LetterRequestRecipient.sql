CREATE TABLE [dbo].[LetterRequestRecipient]
(
[LetterRequestRecipientID] [int] NOT NULL IDENTITY(1, 1),
[LetterRequestID] [int] NOT NULL,
[AccountID] [int] NOT NULL,
[Seq] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[CustomerCode] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorAttorney] [bit] NOT NULL CONSTRAINT [DF_LetterRequestRecipient_DebtorAttorney] DEFAULT (0),
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_LetterRequestRecipient_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_LetterRequestRecipient_DateUpdated] DEFAULT (getdate()),
[AttorneyID] [int] NULL,
[AltRecipient] [bit] NOT NULL CONSTRAINT [def_LetterRequestRecipient_AlternateRecipient] DEFAULT ((0)),
[AltName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltBusinessName] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltState] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltZipcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltEmail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AltFax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecureRecipientID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterRequestRecipient] ADD CONSTRAINT [PK_LetterRequestRecipient] PRIMARY KEY CLUSTERED ([LetterRequestRecipientID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_LetterRequestRecipient_LetterRequestID] ON [dbo].[LetterRequestRecipient] ([LetterRequestID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterRequestRecipient] ADD CONSTRAINT [FK_LetterRequestRecipient_LetterRequest] FOREIGN KEY ([LetterRequestID]) REFERENCES [dbo].[LetterRequest] ([LetterRequestID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table retains recipient, attorney and or alternate name and address information for respective letterrequest.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Business name of alternate recipient', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AltBusinessName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City of alternate recipient', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AltCity'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email address of alternate recipient', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AltEmail'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fax number of alternate recipient', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AltFax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Full name of alternate recipient', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AltName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'When set indicates an alternate destination for letter', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AltRecipient'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State of alternate recipient', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AltState'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 1 of alternate recipient', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AltStreet1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 2 of alternate recipient', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AltStreet2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Zipcode of alternate recipient', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AltZipcode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity ID of subject debtor''s attorney ', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'AttorneyID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer code assigned to the debtor account', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'CustomerCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp created', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set send letter to Debtors Attorney', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'DebtorAttorney'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique debtor ID for the primary debtor on the account', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of parent Letterrequest (foreign key)', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'LetterRequestID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity ID', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequestRecipient', 'COLUMN', N'LetterRequestRecipientID'
GO
