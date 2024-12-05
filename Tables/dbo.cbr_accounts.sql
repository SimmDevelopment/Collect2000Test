CREATE TABLE [dbo].[cbr_accounts]
(
[accountID] [int] NOT NULL,
[customerID] [int] NOT NULL,
[primaryDebtorID] [int] NOT NULL,
[portfolioType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[accountType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[accountStatus] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[originalLoan] [money] NOT NULL CONSTRAINT [DF__cbr_accou__origi__63456846] DEFAULT (0),
[actualPayment] [money] NOT NULL CONSTRAINT [DF__cbr_accou__actua__64398C7F] DEFAULT (0),
[currentBalance] [money] NOT NULL CONSTRAINT [DF__cbr_accou__curre__652DB0B8] DEFAULT (0),
[amountPastDue] [money] NOT NULL CONSTRAINT [DF__cbr_accou__amoun__6621D4F1] DEFAULT (0),
[termsDuration] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[specialComment] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[complianceCondition] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[openDate] [datetime] NOT NULL,
[billingDate] [datetime] NOT NULL,
[delinquencyDate] [datetime] NOT NULL,
[closedDate] [datetime] NULL,
[lastPaymentDate] [datetime] NULL,
[originalCreditor] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[creditorClassification] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[written] [bit] NOT NULL CONSTRAINT [DF__cbr_accou__writt__6715F92A] DEFAULT (0),
[lastUpdated] [datetime] NOT NULL,
[lastReported] [datetime] NULL,
[lastFileID] [int] NULL,
[batchID] [uniqueidentifier] NOT NULL,
[ConsumerAccountNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeOffAmount] [money] NULL,
[PaymentHistoryProfile] [varchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentHistoryDate] [datetime] NULL,
[CreditLimit] [money] NULL,
[specialCommentOverride] [bit] NULL,
[SecondaryAgencyIdenitifier] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecondaryAccountNumber] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MortgageIdentificationNumber] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PortfolioIndicator] [int] NULL,
[SoldToPurchasedFrom] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Cbr_Accounts_Update] ON [dbo].[cbr_accounts]
    AFTER UPDATE
AS
    IF APP_NAME() LIKE '%latitude%'
        AND ISNULL((SELECT CAST(CONTEXT_INFO() AS VARCHAR(30))),'') NOT LIKE '%cbrevaluate%'
        
        BEGIN
		
			IF  UPDATE(specialComment) 
				UPDATE  dbo.cbr_accounts
				SET     lastupdated = GETDATE()
				FROM    dbo.cbr_accounts
					    INNER JOIN DELETED ON cbr_accounts.accountID = DELETED.accountID
						INNER JOIN INSERTED ON DELETED.accountID = INSERTED.accountID
				WHERE   ISNULL(INSERTED.specialComment, '') <> ISNULL(DELETED.specialComment, '') ;
				

										
			IF	UPDATE(complianceCondition) BEGIN 
			
				UPDATE	dbo.cbr_accounts
				SET		lastUpdated = GETDATE()
				FROM    dbo.cbr_accounts
					    INNER JOIN DELETED ON cbr_accounts.accountID = DELETED.accountID
						INNER JOIN INSERTED ON DELETED.accountID = INSERTED.accountID
				WHERE	RTRIM(ISNULL(INSERTED.complianceCondition,'')) <> RTRIM(ISNULL(DELETED.complianceCondition,'')) 
				AND		RTRIM(ISNULL(INSERTED.complianceCondition,'')) <> '';
					   				
			END;
		
			
        END ;
GO
ALTER TABLE [dbo].[cbr_accounts] ADD CONSTRAINT [PK_cbr_accounts] PRIMARY KEY CLUSTERED ([accountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cbr_accounts_accountstatus] ON [dbo].[cbr_accounts] ([accountStatus]) INCLUDE ([accountID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cbr_accounts_batchID] ON [dbo].[cbr_accounts] ([batchID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cbr_accounts_lastFileID] ON [dbo].[cbr_accounts] ([lastFileID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cbr_accounts_lastReported] ON [dbo].[cbr_accounts] ([lastReported]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cbr_accounts_lastUpdated] ON [dbo].[cbr_accounts] ([lastUpdated]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pending table used to maintain current reportable accounts as per the evaluation conditions defined with the Credit Bureau Reporting Console.  This table is updated by the work form when an account is processed and by the Custodian task CBR Evaluate accounts.  The Credit reporting wizard uses this table as input to generate the Metro 2 formatted Credit Report.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'accountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account status reported to the Bureau:  93 - Active, 62 - Pif or Sif, DA - Delete, DF - Delete Fraud', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'accountStatus'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account type reported to the Bureau, configured with CBR Reporting Console.  48 - Collection Agency/Attorney 77 - Returned Check 0C - Factoring Company Account/Debt Purchaser ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'accountType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance owed on account', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'amountPastDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Uniqueidentifier of batch populated by evaluation routines.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'batchID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the account is initially reported to Bureau', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'billingDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the account was closed/returned, deleted or paid in full.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'closedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Allows the reporting of a condition that is required for legal compliance; e.g., according to the Fair Credit Reporting Act (FCRA) or Fair Credit Billing Act (FCBA). Values available: XA = Account closed at consumers request. XB = Account information disputed by consumer. (Meets requirements of the Fair Credit Reporting Act) XC = Completed investigation of FCRA dispute- consumer disagrees. XD= Account closed at consumers request and in dispute under FCRA. XE = Account closed at consumers request and dispute investigation completed. consumer disagrees. (To be used for FCRA or FCBA disputes.) XF = Account in dispute under Fair Credit Billing Act. XG = FCBA Dispute resolved- consumer disagrees. XH = Account previously in dispute - now resolved, reported by data furnisher. XJ = Account closed at consumers request and in dispute under FCBA XR = Removes the most recently reported Compliance Condition Code. ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'complianceCondition'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Creditor Class as noted on the Customer or as defined in the CBR reporting cosole.   Contains a code indicating a general type of business for the Original Creditor Name. Values available: 01 Retail 02 Medical/Health Care 03 Oil Company 04 Government 05 Personal Services 06 Insurance 07 Educational 08 Banking 09 Rental/Leasing 10 Utilities 11 Cable/Cellular 12 Financial 13 Credit Union 14 Automotive 15 Check Guarantee', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'creditorClassification'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance owed on account', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'currentBalance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Customer Identity', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'customerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of original delinquency noted on the debtor account', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'delinquencyDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FileID of report last generated by the wizard that included the account.  Retained in CBR_Metro2_Files.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'lastFileID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date last payment made on account.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'lastPaymentDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The last time the account was reported to the Bureau.  This date is updated when the CBR wizard produces the report file.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'lastReported'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date recording the last time the row was updated by the evaluation procedures due to a status, address or balance change etc.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'lastUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Applied to k3 segment for Mortgage industry - Mortgage portfolio.  The MIN indicates that the loan is registered with the Mortgage Electronic Registration Systems, Inc. (MERS), the electronic registry for tracking the ownership of mortgage rights.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'MortgageIdentificationNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date account was originally received or placed by collection agenacy noted on the debtor account. For companies who report returned checks, such as collection agencies, report the date of the check.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'openDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the company or agent who originally opened the account for the consumer as noted on the account, customer or CBR reporting console configuration.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'originalCreditor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Original principal amount noted on account', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'originalLoan'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Applied to K2 segment for Purchased or Sold Accounts. Contains a code representing the type of information being reported. Values available: 1 = Portfolio Purchased From Name 2 = Sold To Name 9 = Remove Previously Reported K2 Segment Information', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'PortfolioIndicator'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Primary Debtor Identity', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'primaryDebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Applied to k3 segment for Mortgage industry - Mortgage portfolio.  Contains the account number as assigned by the secondary marketing agency. If SecondaryAgencyIdenitifier  = 00, this field should be blank filled.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'SecondaryAccountNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Applied to k3 segment for Mortgage industry - Mortgage portfolio.  Contains a code indicating which secondary marketing agency has interest in this loan. Values available: 00 = Agency Identifier not applicable (Used when reporting MIN only) 01 = Fannie Mae 02 = Freddie Mac', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'SecondaryAgencyIdenitifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Applied to K2 segment for Purchased or Sold Accounts. Contains a free-form description of the name of the company from which the portfolio or partial portfolio was purchased or to which the account was sold.  If field Portfolio Indicator = 9, this field should be blank filled', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'SoldToPurchasedFrom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used in conjunction with Account Status  to further define the account .                                                            Contains [blank] or AU  -  Account paid in full for less than the full balance', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'specialComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column update override flag.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'specialCommentOverride'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains the duration of credit extended. Defaulted to  Open = Constant of 001 (One payment as scheduled) for Collections ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'termsDuration'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Written flag used by the CBR reporting wizard during report generation.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_accounts', 'COLUMN', N'written'
GO
