CREATE TABLE [dbo].[LetterRequest_Account]
(
[LetterRequest_AccountId] [bigint] NOT NULL IDENTITY(1, 1),
[LetterRequestId] [int] NOT NULL,
[AccountId] [int] NOT NULL,
[Printed] [bit] NULL,
[PrintedDate] [datetime] NULL,
[Comment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_LetterRequest_Account_CreatedWhen] DEFAULT (getutcdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterRequest_Account] ADD CONSTRAINT [PK_LetterRequest_Account] PRIMARY KEY CLUSTERED ([LetterRequest_AccountId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_LetterRequest_Account_AccountId] ON [dbo].[LetterRequest_Account] ([AccountId]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [uk_LetterRequest_Account] ON [dbo].[LetterRequest_Account] ([LetterRequestId], [AccountId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterRequest_Account] ADD CONSTRAINT [FK_LetterRequest_Account_LetterRequest] FOREIGN KEY ([LetterRequestId]) REFERENCES [dbo].[LetterRequest] ([LetterRequestID])
GO
ALTER TABLE [dbo].[LetterRequest_Account] ADD CONSTRAINT [FK_LetterRequest_Account_Master] FOREIGN KEY ([AccountId]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table contains a relationship of a letterrequest to the accounts that the letter is requested for. Generally these are linked accounts, but not necessarily all of the linked accounts.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest_Account', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign Key to Master table.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest_Account', 'COLUMN', N'AccountId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of any issues or reason why it was not included in letter file.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest_Account', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Name when the record was created', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest_Account', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetime stamp when the record was created', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest_Account', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Key, identity value for this table.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest_Account', 'COLUMN', N'LetterRequest_AccountId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign Key to LetterRequest table.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest_Account', 'COLUMN', N'LetterRequestId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates if the account has been included in a print file or not. Null: pending, 1: written to file, 0: explicitly not written to file (this should be explained in comment). Deleted letter requests have a value of 0, with a comment implying that it was deleted.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest_Account', 'COLUMN', N'Printed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time that the printed value set.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRequest_Account', 'COLUMN', N'PrintedDate'
GO
