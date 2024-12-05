CREATE TABLE [dbo].[cbr_debtors]
(
[debtorID] [int] NOT NULL,
[debtorSeq] [int] NOT NULL,
[accountID] [int] NOT NULL,
[transactionType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[surname] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[middleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[suffix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[generationCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssn] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dob] [datetime] NULL,
[phone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ecoaCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[informationIndicator] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[countryCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zipcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressIndicator] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[residenceCode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastUpdated] [datetime] NOT NULL,
[transactionTypeOverride] [bit] NULL,
[ecoaCodeOverride] [bit] NULL,
[informationIndicatorOverride] [bit] NULL,
[addressIndicatorOverride] [bit] NULL,
[residenceCodeOverride] [bit] NULL,
[AuthorizedUserSegment] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_debtors] ADD CONSTRAINT [PK_cbr_debtors] PRIMARY KEY CLUSTERED ([debtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cbr_debtors_number_id] ON [dbo].[cbr_debtors] ([accountID], [debtorSeq]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cbr_debtors_lastUpdated] ON [dbo].[cbr_debtors] ([lastUpdated]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_debtors] WITH NOCHECK ADD CONSTRAINT [FK_cbr_debtors_cbr_accounts] FOREIGN KEY ([accountID]) REFERENCES [dbo].[cbr_accounts] ([accountID]) ON DELETE CASCADE NOT FOR REPLICATION
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pending table containing responsible Primary debtors and Co-debtors if so configured.  Loaded and updated by the evaluation procedures of the work form and Custodian for enabled customers.  The CBR wizard uses this table to populate the respective segments in the Credit Report File.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'accountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Address line 1 ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'address1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Address line 2  ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'address2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'B - Business Address D - Data reporters default address M - Military Address N - Not Confirmed Address P - Bill Payer Service - Not Consumer Residence S - Secondary Address U - Non-Deliverable Address / Returned Mail Y - Known Address ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'addressIndicator'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column update override flag.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'addressIndicatorOverride'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor City', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'city'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Country code of Debtor', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'countryCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary or Co-Debtor unique identity belonging to the pending account.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'debtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence number of Debtor on account. 0 = Primary.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'debtorSeq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of Birth', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'dob'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Defines the relationship of the primary consumer to the account and designates the account as joint, individual, etc., in compliance with the Equal Credit Opportunity Act. Values available: 1 - Individual 2 - Join Contractual Liability X - Consumer Deceased  Z - Delete Borrower ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'ecoaCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column update override flag.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'ecoaCodeOverride'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor First Name', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'firstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor generation code', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'generationCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1A - Personal Receivership A - Petition for Chapter 7 Bankruptcy B - Petition for Chapter 11 Bankruptcy C - Petition for Chapter 12 Bankruptcy D - Petition for Chapter 13 Bankruptcy E - Discharged through Bankruptcy Chapter 7  F - Discharged through Bankruptcy Chapter 11 G - Discharged through Bankruptcy Chapter 12  H - Discharged through Bankruptcy Chapter 13 I - Chapter 7 Bankruptcy Dismissed J - Chapter 11 Bankruptcy Dismissed K - Chapter 12 Bankruptcy Dismissed L - Chapter 13 Bankruptcy Dismissed M - Chapter 7 Bankruptcy Withdrawn N - Chapter 11 Bankruptcy Withdrawn O - Chapter 12 Bankruptcy Withdrawn P - Chapter 13 Bankruptcy Withdrawn Q - Remove Previously Reported Bankruptcy T - Credit Grantor Cannot Locate Consumer U - Consumer now Located.  Remove previously reported Z - Bankruptcy  Undesignated Chapter ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'informationIndicator'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column update override flag.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'informationIndicatorOverride'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date recording the last time the row was updated by the evaluation procedures due to an address change etc.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'lastUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Middle name.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'middleName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Full name of Debtor', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone Number', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'O - Owns R - Rents ', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'residenceCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column update override flag.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'residenceCodeOverride'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Social Security Number', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'ssn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor State', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'state'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor suffix', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'suffix'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Surname', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'surname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relates to Consumer Transaction Type. Used to indicate a new record, a new borrower or a change in consumer identification. Values available: 1 = Newly opened account, or new borrower associated with existing account 2 = Name change 3 = Address change 5 = Social Security Number change 6 = Name & Address change 8 = Name & Social Security Number change 9 = Address & Social Security Number change A = Name, Address and/or Social Security Number change If account or borrower is not new,', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'transactionType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column update override flag.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'transactionTypeOverride'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'cbr_debtors', 'COLUMN', N'zipcode'
GO
