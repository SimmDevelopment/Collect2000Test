CREATE TABLE [dbo].[ImportNBDebtors]
(
[Number] [int] NULL,
[Seq] [int] NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WorkPhone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MR] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DOB] [datetime] NULL,
[JobName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobAddr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Jobaddr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobCSZ] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobMemo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Relationship] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spouse] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseJobName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseJobAddr1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseJobAddr2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseJobCSZ] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseJobMemo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseHomePhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseWorkPhone] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseResponsible] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pager] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhoneType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone2Type] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone3] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherPhone3Type] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DebtorMemo] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[language] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DLNum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF__ImportNBD__DateC__2BD537CB] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF__ImportNBD__DateU__2CC95C04] DEFAULT (getdate())
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table for NewBusiness load', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors City', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date this Debtor row was created', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date this debtor was last updated', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Generic Comment', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'DebtorMemo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Drivers License number', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'DLNum'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors date of Birth', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'DOB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors email Address', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Fax Number', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Fax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Home Phone', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'HomePhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employers street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'JobAddr1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employers street address line 2', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Jobaddr2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employers City,State And Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'JobCSZ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employers generic comment', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'JobMemo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Employer Name', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'JobName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Language, relates to Langcodes table', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'language'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors mail Return Flag (''Y'' - Bad Address ''N''- Good Address)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'MR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors name', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique file number related to Master.number', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Other name', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'OtherName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'OtherPhone1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'OtherPhone2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'OtherPhone2Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'OtherPhone3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'OtherPhone3Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'OtherPhoneType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors pager number', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Pager'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relationship of Debtor to the account', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Relationship'
GO
EXEC sp_addextendedproperty N'MS_Description', N'indicates debtor responsibility.  0 = primary responsible party', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Seq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse name', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Spouse'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse Home Phone', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'SpouseHomePhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse employer street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'SpouseJobAddr1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse employer street address line 2', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'SpouseJobAddr2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse employer City,State and Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'SpouseJobCSZ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse employer street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'SpouseJobMemo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse employer name', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'SpouseJobName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicated that debtor is responsible for the debt as well (1- Responsible 0-Not ', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'SpouseResponsible'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse work Phone', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'SpouseWorkPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Social Security Number (SSN)', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors State', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors street address line 2', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Work Phone', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'WorkPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'ImportNBDebtors', 'COLUMN', N'Zipcode'
GO
