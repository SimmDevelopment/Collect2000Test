CREATE TABLE [dbo].[PasswordHistory]
(
[UID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__PasswordHis__UID__5F74D762] DEFAULT (newid()),
[UserID] [int] NOT NULL,
[Date] [datetime] NOT NULL CONSTRAINT [DF__PasswordHi__Date__6068FB9B] DEFAULT (getdate()),
[PasswordHash] [int] NULL,
[PasswordHashSHA512] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PasswordSalt] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PasswordHistory] ADD CONSTRAINT [pk_PasswordHistory] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PasswordHistory] WITH NOCHECK ADD CONSTRAINT [fk_PasswordHistory_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Created or updated', 'SCHEMA', N'dbo', 'TABLE', N'PasswordHistory', 'COLUMN', N'Date'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identifier for each record', 'SCHEMA', N'dbo', 'TABLE', N'PasswordHistory', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID Field from Users Table ', 'SCHEMA', N'dbo', 'TABLE', N'PasswordHistory', 'COLUMN', N'UserID'
GO
