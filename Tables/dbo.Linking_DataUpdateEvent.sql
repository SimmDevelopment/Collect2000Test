CREATE TABLE [dbo].[Linking_DataUpdateEvent]
(
[DebtorID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Linking_DataUpdateEvent] ADD CONSTRAINT [PK__Linking_DataUpda__122052C0] PRIMARY KEY NONCLUSTERED ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is populated by a trigger on the Debtors table that Inserts into this table the respective DebtorID that has had a change to any of the configured link settings.  (Name, Phone etc.)  Linking will re-evaluate these respective accounts.', 'SCHEMA', N'dbo', 'TABLE', N'Linking_DataUpdateEvent', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Identoty Key value', 'SCHEMA', N'dbo', 'TABLE', N'Linking_DataUpdateEvent', 'COLUMN', N'DebtorID'
GO
