CREATE TABLE [dbo].[Linking_ActionsPending]
(
[UID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF__Linking_Act__UID__363DB7A5] DEFAULT (newid()),
[Source] [int] NOT NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Target] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Linking_ActionsPending] ADD CONSTRAINT [PK__Linking_ActionsP__1AB598C1] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_ActionsPending_Source] ON [dbo].[Linking_ActionsPending] ([Source]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_ActionsPending_Target] ON [dbo].[Linking_ActionsPending] ([Target]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used by Linking', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ActionsPending', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer code of respective account', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ActionsPending', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Source Account Filenumber ID', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ActionsPending', 'COLUMN', N'Source'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Target FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ActionsPending', 'COLUMN', N'Target'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identifier Key', 'SCHEMA', N'dbo', 'TABLE', N'Linking_ActionsPending', 'COLUMN', N'UID'
GO
