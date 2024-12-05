CREATE TABLE [dbo].[SubscriptionHistory]
(
[UID] [bigint] NOT NULL IDENTITY(1, 1),
[SubscriptionID] [int] NOT NULL,
[Date] [datetime] NOT NULL CONSTRAINT [DF__Subscripti__Date__27FB509D] DEFAULT (getdate()),
[ExpirationEvaluated] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SubscriptionHistory] ADD CONSTRAINT [pk_SubscriptionHistory] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SubscriptionHistory] ADD CONSTRAINT [fk_SubscriptionID] FOREIGN KEY ([SubscriptionID]) REFERENCES [dbo].[Subscriptions] ([UID]) ON DELETE CASCADE
GO
