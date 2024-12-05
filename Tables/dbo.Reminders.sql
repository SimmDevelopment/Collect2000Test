CREATE TABLE [dbo].[Reminders]
(
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountID] [int] NOT NULL,
[Due] [datetime] NOT NULL,
[ReminderDate] [datetime] NOT NULL,
[FollowAccountDesk] [bit] NOT NULL CONSTRAINT [def_Reminders_FollowAccountDesk] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reminders] ADD CONSTRAINT [PK__Reminders__269C4CB9] PRIMARY KEY NONCLUSTERED ([Desk], [AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IDX_Reminders_AccountID] ON [dbo].[Reminders] ([AccountID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reminders] ADD CONSTRAINT [FK__Reminders__Accou__2884952B] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reminders] ADD CONSTRAINT [FK__Reminders__Desk__279070F2] FOREIGN KEY ([Desk]) REFERENCES [dbo].[desk] ([code]) ON DELETE CASCADE
GO
