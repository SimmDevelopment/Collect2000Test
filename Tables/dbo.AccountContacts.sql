CREATE TABLE [dbo].[AccountContacts]
(
[Number] [int] NULL,
[TheDate] [datetime] NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeOn] [datetime] NULL,
[TimeOff] [datetime] NULL,
[Totalseconds] [int] NULL,
[UserID] [int] NULL,
[TimeOnUtc] [datetime] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AccountContacts_Desk] ON [dbo].[AccountContacts] ([Desk]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AccountContacts_Number] ON [dbo].[AccountContacts] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AccountContacts_TheDate] ON [dbo].[AccountContacts] ([TheDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AccountContacts_UserID] ON [dbo].[AccountContacts] ([UserID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account contact transaction history ', 'SCHEMA', N'dbo', 'TABLE', N'AccountContacts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Code at time of contact', 'SCHEMA', N'dbo', 'TABLE', N'AccountContacts', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account FileNumber', 'SCHEMA', N'dbo', 'TABLE', N'AccountContacts', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Contact made with Primary Debtor', 'SCHEMA', N'dbo', 'TABLE', N'AccountContacts', 'COLUMN', N'TheDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time Account was released by Collector', 'SCHEMA', N'dbo', 'TABLE', N'AccountContacts', 'COLUMN', N'TimeOff'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Time Contact Initiated', 'SCHEMA', N'dbo', 'TABLE', N'AccountContacts', 'COLUMN', N'TimeOn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total seconds account was worked', 'SCHEMA', N'dbo', 'TABLE', N'AccountContacts', 'COLUMN', N'Totalseconds'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Unique Identifier', 'SCHEMA', N'dbo', 'TABLE', N'AccountContacts', 'COLUMN', N'UserID'
GO
