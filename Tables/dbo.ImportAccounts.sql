CREATE TABLE [dbo].[ImportAccounts]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[BatchID] [int] NOT NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OtherName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ZipCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DOB] [datetime] NULL,
[Customer] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsPODAcct] [bit] NOT NULL CONSTRAINT [DF_ImportAccounts_IsPODAcct] DEFAULT (0),
[AccountNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Received] [datetime] NOT NULL,
[Original] [money] NOT NULL,
[Original1] [money] NOT NULL,
[Original2] [money] NOT NULL,
[Original3] [money] NOT NULL,
[Original4] [money] NOT NULL,
[Original5] [money] NOT NULL,
[Original6] [money] NOT NULL,
[Original7] [money] NOT NULL,
[Original8] [money] NOT NULL,
[Original9] [money] NOT NULL,
[Original10] [money] NOT NULL,
[CurrencyType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CLIDLP] [datetime] NULL,
[CLIDLI] [datetime] NULL,
[CLIDLC] [datetime] NULL,
[IntRate] [real] NOT NULL CONSTRAINT [DF_ImportAccounts_IntRate] DEFAULT (0),
[HomePhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkPhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Branch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DelinquencyDate] [datetime] NULL,
[BigNote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImportAccounts] ADD CONSTRAINT [PK_ImportAccounts] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table used by Import Excel', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'AccountNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Batch Identity of Import', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'BatchID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free form text field that will be added to the respective accounts BIGNOTE table.', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'BigNote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branchcode Account will belong to', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Branch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors city, also replicated in debtors table (debtors.city)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clients date of Last charge', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'CLIDLC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clients date of Last interest charge', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'CLIDLI'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clients date of Last payment', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'CLIDLP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'CurrencyType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current customer or portfolio assigned to account', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The FCRA Compliance/Date of First Delinquency .', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'DelinquencyDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors date of birth, replicated in debtors table (Debtors.dob)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'DOB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors home phone number, also replicated in debtors table (debtors.hom', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'HomePhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'interest rate', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'IntRate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set loads the respective POD tables', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'IsPODAcct'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Debtors name, also replicated in debtors table (debtors.name)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total original balance (Sum of Original1...Original10 buckets)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Original'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket1 (principal)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Original1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Should Not Be Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Original10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket2 (Interest)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Original2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket3 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Original3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket4 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Original4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket5 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Original5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket6 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Original6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket7 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Original7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket8 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Original8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket9 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Original9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date account listed on system', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Received'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors social security number(SSN), also replicated in debtors table(De', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors state, also replicated in debtors table (debtors.state)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors street address line 1, also replicated in debtors table (debtors', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors street address line 2, also replicated in debtors table (debtors', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors work phone number, also replicated in debtors table (debtors.wor', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'WorkPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors zipcode, also replicated in debtors table (debtors.zipcode)', 'SCHEMA', N'dbo', 'TABLE', N'ImportAccounts', 'COLUMN', N'ZipCode'
GO
