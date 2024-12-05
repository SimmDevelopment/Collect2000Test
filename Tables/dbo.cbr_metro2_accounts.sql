CREATE TABLE [dbo].[cbr_metro2_accounts]
(
[recordID] [int] NOT NULL IDENTITY(1, 1),
[fileID] [int] NOT NULL,
[dateReported] [datetime] NULL,
[accountID] [int] NOT NULL,
[customerID] [int] NOT NULL,
[primaryDebtorID] [int] NOT NULL,
[portfolioType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[accountType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[accountStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[originalLoan] [money] NOT NULL CONSTRAINT [DF__cbr_metro__origi__46A92998] DEFAULT (0),
[actualPayment] [money] NOT NULL CONSTRAINT [DF__cbr_metro__actua__479D4DD1] DEFAULT (0),
[currentBalance] [money] NOT NULL CONSTRAINT [DF__cbr_metro__curre__4891720A] DEFAULT (0),
[amountPastDue] [money] NOT NULL CONSTRAINT [DF__cbr_metro__amoun__49859643] DEFAULT (0),
[termsDuration] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[specialComment] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[complianceCondition] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__cbr_metro__compl__691284DE] DEFAULT (''),
[openDate] [datetime] NOT NULL,
[billingDate] [datetime] NOT NULL,
[delinquencyDate] [datetime] NOT NULL,
[closedDate] [datetime] NULL,
[lastPaymentDate] [datetime] NULL,
[originalCreditor] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[creditorClassification] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConsumerAccountNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeOffAmount] [money] NULL,
[PaymentHistoryProfile] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentHistoryDate] [datetime] NULL,
[CreditLimit] [money] NULL,
[SecondaryAgencyIdenitifier] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondaryAccountNumber] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MortgageIdentificationNumber] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PortfolioIndicator] [int] NULL,
[SoldToPurchasedFrom] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_metro2_accounts] ADD CONSTRAINT [PK_cbr_metro2_accounts] PRIMARY KEY CLUSTERED ([recordID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cbr_metro2_accounts_accountID_fileID] ON [dbo].[cbr_metro2_accounts] ([accountID], [fileID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_metro2_accounts_accountstatus] ON [dbo].[cbr_metro2_accounts] ([accountStatus]) INCLUDE ([accountID], [fileID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cbr_metro2_accounts_complianceCondition] ON [dbo].[cbr_metro2_accounts] ([complianceCondition]) INCLUDE ([accountID], [fileID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cbr_metro2_accounts_fileID] ON [dbo].[cbr_metro2_accounts] ([fileID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_metro2_accounts] ADD CONSTRAINT [FK_cbr_metro2_accounts_cbr_metro2_files] FOREIGN KEY ([fileID]) REFERENCES [dbo].[cbr_metro2_files] ([fileID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Historical table containing copy of cbr_accounts as reported for respective report.  Populated each time the CBR wizard produces a report.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'accountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account status reported to the Bureau:  93 - Active, 62 - Pif or Sif, DA - Delete, DF - Delete Fraud', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'accountStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account type reported to the Bureau, configured with CBR Reporting Console.  48 - Collection Agency/Attorney 77 - Returned Check 0C - Factoring Company Account/Debt Purchaser ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'accountType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance owed on account', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'amountPastDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the account is initially reported to Bureau', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'billingDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the account was closed/returned, deleted or paid in full.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'closedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Allows the reporting of a condition that is required for legal compliance; e.g., according to the Fair Credit Reporting Act (FCRA) or Fair Credit Billing Act (FCBA). Values available: XA = Account closed at consumers request. XB = Account information disputed by consumer. (Meets requirements of the Fair Credit Reporting Act) XC = Completed investigation of FCRA dispute - consumer disagrees. XD = Account closed at consumers request and in dispute under FCRA. XE = Account closed at consumers request and dispute investigation completed, consumer disagrees. (To be used for FCRA or FCBA disputes.) XF = Account in dispute under Fair Credit Billing Act. XG = FCBA Dispute resolved - consumer disagrees. XH = Account previously in dispute - now resolved, reported by data furnisher. XJ = Account closed at consumers request and in dispute under FCBA XR = Removes the most recently reported Compliance Condition Code.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'complianceCondition'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Creditor Class as noted on the Customer or as defined in the CBR reporting cosole.   Contains a code indicating a general type of business for the Original Creditor Name. Values available: 01 Retail 02 Medical/Health Care 03 Oil Company 04 Government 05 Personal Services 06 Insurance 07 Educational 08 Banking 09 Rental/Leasing 10 Utilities 11 Cable/Cellular 12 Financial 13 Credit Union 14 Automotive 15 Check Guarantee', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'creditorClassification'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance owed on account', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'currentBalance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Customer Identity', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'customerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date report generated.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'dateReported'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of original delinquency noted on the debtor account', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'delinquencyDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique File identity relating to cbr_metro2_files.  Each reported generated received a FileID.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'fileID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date last payment made on account.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'lastPaymentDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Applied to k3 segment for Mortgage industry - Mortgage portfolio.  The MIN indicates that the loan is registered with the Mortgage Electronic Registration Systems, Inc. (MERS), the electronic registry for tracking the ownership of mortgage rights.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'MortgageIdentificationNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date account was originally received or placed by collection agenacy noted on the debtor account. For companies who report returned checks, such as collection agencies, report the date of the check.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'openDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the company or agent who originally opened the account for the consumer as noted on the account, customer or CBR reporting console configuration.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'originalCreditor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Original principal amount noted on account', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'originalLoan'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Applied to K2 segment for Purchased or Sold Accounts. Contains a code representing the type of information being reported. Values available: 1 = Portfolio Purchased From Name 2 = Sold To Name 9 = Remove Previously Reported K2 Segment Information', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'PortfolioIndicator'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Primary Debtor Identity', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'primaryDebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Record Identoty relating to child cbr_metro2_debtors', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'recordID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Applied to k3 segment for Mortgage industry - Mortgage portfolio.  Contains the account number as assigned by the secondary marketing agency. If SecondaryAgencyIdenitifier  = 00, this field should be blank filled.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'SecondaryAccountNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Applied to k3 segment for Mortgage industry - Mortgage portfolio.  Contains a code indicating which secondary marketing agency has interest in this loan. Values available: 00 = Agency Identifier not applicable (Used when reporting MIN only) 01 = Fannie Mae 02 = Freddie Mac', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'SecondaryAgencyIdenitifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Applied to K2 segment for Purchased or Sold Accounts. Contains a free-form description of the name of the company from which the portfolio or partial portfolio was purchased or to which the account was sold.  If field Portfolio Indicator = 9, this field should be blank filled', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'SoldToPurchasedFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used in conjunction with Account Status  to further define the account .                                                            Contains [blank] or AU  -  Account paid in full for less than the full balance', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'specialComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains the duration of credit extended. Defaulted to  Open = Constant of 001 (One payment as scheduled) for Collections ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_accounts', 'COLUMN', N'termsDuration'
GO
