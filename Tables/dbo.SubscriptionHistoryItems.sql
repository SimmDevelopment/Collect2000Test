CREATE TABLE [dbo].[SubscriptionHistoryItems]
(
[UID] [bigint] NOT NULL IDENTITY(1, 1),
[SubscriptionHistoryID] [bigint] NOT NULL,
[AccountID] [int] NOT NULL,
[SourceDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DestinationDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ExpirationDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SubscriptionHistoryItems] ADD CONSTRAINT [pk_SubscriptionHistoryItems] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SubscriptionHistoryItems] ADD CONSTRAINT [fk_SubscriptionHistoryID] FOREIGN KEY ([SubscriptionHistoryID]) REFERENCES [dbo].[SubscriptionHistory] ([UID]) ON DELETE CASCADE
GO
