CREATE TABLE [dbo].[Phonecall_Attempts]
(
[PhonecallAttemptsID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[MasterPhoneID] [int] NULL,
[LoginName] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttemptDate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phonecall_Attempts] ADD CONSTRAINT [pk_Phonecall_Attempts] PRIMARY KEY NONCLUSTERED ([PhonecallAttemptsID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phonecall_Attempts] ADD CONSTRAINT [FK__Phonecall__Maste__6B6FCE9C] FOREIGN KEY ([MasterPhoneID]) REFERENCES [dbo].[Phones_Master] ([MasterPhoneID])
GO
ALTER TABLE [dbo].[Phonecall_Attempts] ADD CONSTRAINT [FK_Phonecall_Attempts_Debtors] FOREIGN KEY ([DebtorID]) REFERENCES [dbo].[Debtors] ([DebtorID])
GO
ALTER TABLE [dbo].[Phonecall_Attempts] ADD CONSTRAINT [FK_Phonecall_Attempts_master] FOREIGN KEY ([number]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains all the valid phone call attempts to contact a particular debtor on an account.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Attempts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the attempt to contact took place.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Attempts', 'COLUMN', N'AttemptDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Debtors table.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Attempts', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude login name or Latitude app (if no agent involved) when record created.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Attempts', 'COLUMN', N'LoginName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Phones_Master table (Nullable).', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Attempts', 'COLUMN', N'MasterPhoneID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Master table.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Attempts', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identifier for this record.', 'SCHEMA', N'dbo', 'TABLE', N'Phonecall_Attempts', 'COLUMN', N'PhonecallAttemptsID'
GO
