CREATE TABLE [dbo].[DebtorAttorneys]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Firm] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Addr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Addr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Zipcode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Fax] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Comments] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF__DebtorAtt__DateC__41CE9A8B] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF__DebtorAtt__DateU__42C2BEC4] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DebtorAttorneys] ADD CONSTRAINT [PK_DebtorAttorneys] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DebtorAttorneys_AccountID] ON [dbo].[DebtorAttorneys] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DebtorAttorneys_DebtorID] ON [dbo].[DebtorAttorneys] ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor''s Attorney', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'FileNumber - Master.Number ', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address line 1 for Attorney ', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'Addr1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address line 2 for Attorney', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'Addr2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address City ', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'General Comments', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'Comments'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date entered in system', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date last updated in system', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor unique identifier - Debtors.Debtorid ', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email for Attorney contact', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fax number for Attorney', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'Fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of Attorneys Firm', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'Firm'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Auto Generated Unique Identifier ', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Attorney Name representing Debtor', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact phone number for Attorney', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing address State', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mailing Address ZipCode', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAttorneys', 'COLUMN', N'Zipcode'
GO
