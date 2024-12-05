CREATE TABLE [dbo].[Phonecall_Contacts]
(
[PhonecallContactsID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[ContactDate] [smalldatetime] NOT NULL,
[ExpressConsentDate] [smalldatetime] NULL,
[PhonecallAttemptsID] [int] NULL,
[LoginName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phonecall_Contacts] ADD CONSTRAINT [pk_Phonecall_Contacts] PRIMARY KEY NONCLUSTERED ([PhonecallContactsID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phonecall_Contacts] ADD CONSTRAINT [FK__Phonecall__Phone__703483B9] FOREIGN KEY ([PhonecallAttemptsID]) REFERENCES [dbo].[Phonecall_Attempts] ([PhonecallAttemptsID])
GO
ALTER TABLE [dbo].[Phonecall_Contacts] ADD CONSTRAINT [FK_Phonecall_Contacts_Debtors] FOREIGN KEY ([DebtorID]) REFERENCES [dbo].[Debtors] ([DebtorID])
GO
ALTER TABLE [dbo].[Phonecall_Contacts] ADD CONSTRAINT [FK_Phonecall_Contacts_master] FOREIGN KEY ([number]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains a record for all phone contacts with any particular debtor on an account.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Contacts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the actual contact took place.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Contacts', 'COLUMN', N'ContactDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Debtors table.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Contacts', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date given for express consent to call.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Contacts', 'COLUMN', N'ExpressConsentDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude user or app when record created.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Contacts', 'COLUMN', N'LoginName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Master table.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Contacts', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to phonecall_attempts table (Nullable).', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Contacts', 'COLUMN', N'PhonecallAttemptsID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identifier for this record.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Contacts', 'COLUMN', N'PhonecallContactsID'
GO
