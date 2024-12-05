CREATE TABLE [dbo].[Settlement]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[SettlementAmount] [money] NULL,
[ExpirationDays] [int] NOT NULL,
[CreatedBy] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__Settlemen__Creat__266119A1] DEFAULT (getdate()),
[Updated] [datetime] NOT NULL CONSTRAINT [DF__Settlemen__Updat__27553DDA] DEFAULT (getdate()),
[SettlementTotalAmount] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Settlement] ADD CONSTRAINT [pk_Settlement] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Settlement] ADD CONSTRAINT [fk_Settlement_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Settlement Table', 'SCHEMA', N'dbo', 'TABLE', N'Settlement', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The file number of the affected account, foreign key to master.number', 'SCHEMA', N'dbo', 'TABLE', N'Settlement', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date/time that the settlement was entered', 'SCHEMA', N'dbo', 'TABLE', N'Settlement', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude user who entered the settlement', 'SCHEMA', N'dbo', 'TABLE', N'Settlement', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'(Not Implemented)', 'SCHEMA', N'dbo', 'TABLE', N'Settlement', 'COLUMN', N'ExpirationDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique identity assigned to this record', 'SCHEMA', N'dbo', 'TABLE', N'Settlement', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The agreed settlement amount for the account.  When the total paid on this account exceeds this amount the account is to be considered settled in full', 'SCHEMA', N'dbo', 'TABLE', N'Settlement', 'COLUMN', N'SettlementAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The last date/time that the settlement was updated', 'SCHEMA', N'dbo', 'TABLE', N'Settlement', 'COLUMN', N'Updated'
GO
