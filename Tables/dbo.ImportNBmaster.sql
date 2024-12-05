CREATE TABLE [dbo].[ImportNBmaster]
(
[number] [int] NOT NULL,
[link] [int] NULL,
[LinkDriver] [bit] NULL,
[desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MR] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalCreditor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[homephone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[workphone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[specialnote] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[received] [datetime] NULL,
[closed] [datetime] NULL,
[returned] [datetime] NULL,
[lastpaid] [datetime] NULL,
[lastpaidamt] [money] NULL,
[lastinterest] [datetime] NULL,
[interestrate] [money] NULL,
[worked] [datetime] NULL,
[userdate1] [datetime] NULL,
[userdate2] [datetime] NULL,
[userdate3] [datetime] NULL,
[contacted] [datetime] NULL,
[status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original] [money] NULL,
[original1] [money] NULL,
[original2] [money] NULL,
[original3] [money] NULL,
[original4] [money] NULL,
[original5] [money] NULL,
[original6] [money] NULL,
[original7] [money] NULL,
[original8] [money] NULL,
[original9] [money] NULL,
[original10] [money] NULL,
[Accrued2] [money] NULL,
[Accrued10] [money] NULL,
[paid] [money] NULL,
[paid1] [money] NULL,
[paid2] [money] NULL,
[paid3] [money] NULL,
[paid4] [money] NULL,
[paid5] [money] NULL,
[paid6] [money] NULL,
[paid7] [money] NULL,
[paid8] [money] NULL,
[paid9] [money] NULL,
[paid10] [money] NULL,
[current0] [money] NULL,
[current1] [money] NULL,
[current2] [money] NULL,
[current3] [money] NULL,
[current4] [money] NULL,
[current5] [money] NULL,
[current6] [money] NULL,
[current7] [money] NULL,
[current8] [money] NULL,
[current9] [money] NULL,
[current10] [money] NULL,
[attorney] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyID] [int] NULL,
[assignedattorney] [datetime] NULL,
[promamt] [money] NULL,
[promdue] [datetime] NULL,
[sifpct] [money] NULL,
[queue] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qflag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qtime] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[extracodes] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salary] [money] NULL,
[feecode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clidlc] [datetime] NULL,
[clidlp] [datetime] NULL,
[seq] [int] NULL,
[Pseq] [int] NOT NULL,
[Branch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Finders] [datetime] NULL,
[COMPLETE1] [datetime] NULL,
[Complete2] [datetime] NULL,
[DESK1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESK2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Full0] [datetime] NULL,
[TotalViewed] [int] NOT NULL,
[TotalWorked] [int] NOT NULL,
[TotalContacted] [int] NOT NULL,
[nsf] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasBigNote] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstReceived] [datetime] NULL,
[AgencyFlag] [tinyint] NULL,
[AgencyCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustDivision] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustDistrict] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustBranch] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Delinquencydate] [datetime] NULL,
[CurrencyType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[sysmonth] [tinyint] NULL,
[SysYear] [smallint] NULL,
[DMDateStamp] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id1] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PurchasedPortfolio] [int] NULL,
[SoldPortfolio] [int] NULL,
[BPDate] [datetime] NULL,
[NSFDate] [datetime] NULL,
[ContractDate] [datetime] NULL,
[ChargeOffDate] [datetime] NULL,
[ShouldQueue] [bit] NOT NULL,
[RestrictedAccess] [bit] NOT NULL CONSTRAINT [DF_ImportNBmaster_RestrictedAccess] DEFAULT (0),
[Score] [smallint] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table for Import of New Business', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clients Account number.  This is the reference number that the creditor uses to ', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'account'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction surcharges applied aginst account since placement', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Accrued10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Interest accrued aginst account since placement', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Accrued2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'AgencyCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'AgencyFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date account was assigned to account', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'assignedattorney'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Attorney Code assigned to account( Relates to Attorney table)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'attorney'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Attorney ID assogned to account( Relates to Attorney table)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'AttorneyID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last date Account was a broken promise', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'BPDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch where account is located', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Branch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date account was charged off', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'ChargeOffDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors city, also replicated in debtors table (debtors.city)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clients date of Last charge', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'clidlc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clients date of Last payment', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'clidlp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date account was assigned a closed type status code', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'closed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'COMPLETE1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Complete2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date account was last contacted (contacted defined as result code used that is c', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'contacted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date account was opened with original creditor', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'ContractDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'CurrencyType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Current balance (Sum of Current 1...Current10 Buckets)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'current0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Principal balance', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'current1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 10', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'current10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Interest Balance', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'current2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 3', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'current3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 4', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'current4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 5', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'current5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 6', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'current6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 7', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'current7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 8', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'current8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 9', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'current9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined Column', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'CustBranch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Defined Column', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'CustDistrict'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined Column', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'CustDivision'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current customer or portfolio assigned to account', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The FCRA Compliance/Date of First Delinquency .', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Delinquencydate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk code Assigned to Account', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'DESK1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'DESK2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'DMDateStamp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors date of birth, replicated in debtors table (Debtors.dob)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'DOB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'extracodes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If populated this Feecode will override that belonging to the respective Customer', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'FeeSchedule'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Finders'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'FirstDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'FirstReceived'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Full0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account has a big note table entry (1=Yes 0=No)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'HasBigNote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors home phone number, also replicated in debtors table (debtors.hom', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'homephone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Additional account identifier', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'id1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Additional account identifier', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'id2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'interest rate', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'interestrate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last date interest was calculated on account', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'lastinterest'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last date a payment was posted to account', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'lastpaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'amount of the last payment posted to account', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'lastpaidamt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A reference number that logically associates different accounts into a ''linked'' ', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'link'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If this is set to 1 this account is the driver of the accounts within the same l', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'LinkDriver'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Debtor mail Return Flag (''Y'' - Bad Address ''N''- Good Address), also repl', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'MR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Debtors name, also replicated in debtors table (debtors.name)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account has had NSF Payment applied (1=Yes 0=No)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'nsf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'NSFDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique number assigned to each account in Latitude', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total original balance (Sum of Original1...Original10 buckets)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'original'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket1 (principal)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'original1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Should Not Be Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'original10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket2 (Interest)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'original2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket3 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'original3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket4 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'original4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket5 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'original5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket6 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'original6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket7 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'original7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket8 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'original8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket9 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'original9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Original Creditor (For Debt buyers this is the original creditor on the account)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'OriginalCreditor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors Other Name, also replicated in debtors table (debtors.othername)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'other'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Paid (Sum of Paid1...Paid10 Buckets)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'paid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Principal paid on account', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'paid1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 10', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'paid10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Interest paid on account', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'paid2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 3', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'paid3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 4', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'paid4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 5', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'paid5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 6', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'paid6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 7', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'paid7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 8', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'paid8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 9', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'paid9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next promised payment amount', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'promamt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next promised payment date', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'promdue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Pseq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchased Portfolio ID, Relates to Portfolio table', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'PurchasedPortfolio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next Queue date (formated as string YYYYMMDD)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'qdate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'qflag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Queue Level', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'qlevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next time account should be worked (Formated as string HHMM)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'qtime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'queue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date account listed on system', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'received'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If set to 1 the account will not be allowed to be displayed for any users witout', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'RestrictedAccess'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date account was returned to customer (Queue level should also be ''999'')', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'returned'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Salary'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account score ( Score can be loaded from many applications and data sources)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Score'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'seq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If set to 1 then the account will show up in the collector queue, if set to 0 th', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'ShouldQueue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sold Portfolio ID. Relates to Portfolio table', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'SoldPortfolio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'specialnote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors social security number(SSN), also replicated in debtors table(De', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors state, also replicated in debtors table (debtors.state)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Status code on account', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors street address line 1, also replicated in debtors table (debtors', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors street address line 2, also replicated in debtors table (debtors', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting month during which account was received', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'sysmonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting year during which account was received', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'SysYear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of times this account has been contacted. Starts at 0', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'TotalContacted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of time this account has been viewed. Starts at 0', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'TotalViewed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of times this account has been worked. Starts at 0', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'TotalWorked'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined date', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'userdate1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined date', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'userdate2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined date', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'userdate3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date account was last worked (Worked defined as a result code used that is coded', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'worked'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors work phone number, also replicated in debtors table (debtors.wor', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'workphone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors zipcode, also replicated in debtors table (debtors.zipcode)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBmaster', 'COLUMN', N'Zipcode'
GO
