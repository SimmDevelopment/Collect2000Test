CREATE TABLE [dbo].[cbr_exceptions]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number] [int] NULL,
[DebtorId] [int] NULL,
[Reportable] [bit] NULL,
[StatusCbrReport] [bit] NULL,
[StatusCbrDelete] [bit] NULL,
[CbrEnabled] [bit] NULL,
[CbrExclude] [bit] NULL,
[Responsible] [bit] NULL,
[CbrException] [int] NULL,
[OutOfStatute] [bit] NULL,
[DebtorExceptions] [int] NULL,
[IsBusiness] [bit] NULL,
[CbrOverride] [bit] NULL,
[RptDtException] [bit] NULL,
[MinBalException] [bit] NULL,
[CbrExceptionsID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_exceptions] ADD CONSTRAINT [pk_cbr_exceptions] PRIMARY KEY NONCLUSTERED ([CbrExceptionsID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [uq_cbr_exceptions] ON [dbo].[cbr_exceptions] ([Number], [DebtorId]) INCLUDE ([CbrException], [CbrExclude], [Customer], [DebtorExceptions], [IsBusiness], [MinBalException], [OutOfStatute], [Responsible], [RptDtException]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table retains account and debtor identifiers along with flags indicating respective validation error preventing account or debtor from reporting.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer configuration setting', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'CbrEnabled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'"-1,-2, or -3"  Invalid Delinquency date.  "-4"  Invalid account type.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'CbrException'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor exclusion flag', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'CbrExclude'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating manual override on account.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'CbrOverride'
GO
EXEC sp_addextendedproperty N'MS_Description', N'"-1" Invalid Debtor Name.  "-2" Invalid Zipcode.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'DebtorExceptions'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary or Co-Debtor unique identity belonging to the pending account.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'DebtorId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'"1" indicates business which are not reported.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'IsBusiness'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account minimum balance under configured limit.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'MinBalException'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Delinquency date at least 7 years prior to current date.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'OutOfStatute'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag indicating account is not reportable', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'Reportable'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor is responsible flag', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'Responsible'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account may not be reported due to wait days.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'RptDtException'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status flag allowing account to report as deleted when in current status', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'StatusCbrDelete'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status flag allowing account to report when in current status', 'SCHEMA', N'dbo', 'TABLE', N'cbr_exceptions', 'COLUMN', N'StatusCbrReport'
GO
