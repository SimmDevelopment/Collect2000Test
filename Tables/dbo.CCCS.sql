CREATE TABLE [dbo].[CCCS]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DebtorID] [int] NOT NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF__CCCS__DateCreate__3BF690FB] DEFAULT (getdate()),
[DateModified] [datetime] NOT NULL,
[CompanyName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[City] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ZipCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Contact] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClientID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AcceptedAmount] [money] NULL,
[DateAccepted] [datetime] NULL,
[Comments] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CCCS] ADD CONSTRAINT [PK__CCCS__1E3C10E2] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CCCS_DebtorId] ON [dbo].[CCCS] ([DebtorID], [DateCreated] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CCCS] ADD CONSTRAINT [fk_Debtors] FOREIGN KEY ([DebtorID]) REFERENCES [dbo].[Debtors] ([DebtorID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Consumer Credit Counseling Services Information', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount of the debt to be paid. ', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'AcceptedAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CCCS City', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor ID with the CCCS  ', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'ClientID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Case comments', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'Comments'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The counseling company that the debtor has filed with', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'CompanyName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name and demographic information for the CCCS counselor assigned to ', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'Contact'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collection agency''s ID with the CCCS  ', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'CreditorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date that the file was accepted', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'DateAccepted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Row creation date', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Row update timestamp', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'DateModified'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of respective Debtor', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact Fax', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'Fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity ID', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact Phone', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CCCS State', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CCCS Address line 1', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CCCS Address line 2', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CCCS Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'CCCS', 'COLUMN', N'ZipCode'
GO
