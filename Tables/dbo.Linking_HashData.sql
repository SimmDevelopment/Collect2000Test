CREATE TABLE [dbo].[Linking_HashData]
(
[Number] [int] NOT NULL,
[DebtorID] [int] NOT NULL,
[Seq] [int] NOT NULL,
[LastName_Hash] [int] NOT NULL,
[FirstName_Hash] [int] NOT NULL,
[SSN_Hash] [int] NOT NULL,
[Phone_Hash] [int] NOT NULL,
[DLNum_Hash] [int] NOT NULL,
[DOB_Hash] [int] NOT NULL,
[Street_Hash] [int] NOT NULL,
[City_Hash] [int] NOT NULL,
[ZipCode_Hash] [int] NOT NULL,
[Account_Hash] [int] NOT NULL,
[ID1_Hash] [int] NOT NULL,
[ID2_Hash] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Linking_HashData] ADD CONSTRAINT [PK__Linking_HashData__10380A4E] PRIMARY KEY NONCLUSTERED ([DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_Account] ON [dbo].[Linking_HashData] ([Account_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_DLNum] ON [dbo].[Linking_HashData] ([DLNum_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_DOB] ON [dbo].[Linking_HashData] ([DOB_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_FirstName] ON [dbo].[Linking_HashData] ([FirstName_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_FullName] ON [dbo].[Linking_HashData] ([FirstName_Hash], [LastName_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_ID1] ON [dbo].[Linking_HashData] ([ID1_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_ID2] ON [dbo].[Linking_HashData] ([ID2_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_LastName_Hash] ON [dbo].[Linking_HashData] ([LastName_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_City] ON [dbo].[Linking_HashData] ([Number], [City_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_LinkData_Number_DebtorID] ON [dbo].[Linking_HashData] ([Number], [DebtorID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_LastName] ON [dbo].[Linking_HashData] ([Number], [LastName_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_ZipCode] ON [dbo].[Linking_HashData] ([Number], [ZipCode_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_Phone] ON [dbo].[Linking_HashData] ([Phone_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_SSN] ON [dbo].[Linking_HashData] ([SSN_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Linking_HashData_Street] ON [dbo].[Linking_HashData] ([Street_Hash]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table contains hash keys used for linking evaluation and the workform serch engine', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of Debtors account number (client reference)', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'Account_Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of Debtors City', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'City_Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtor Identoty Key value', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of Debtors Drivers license number', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'DLNum_Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of Debtors Date of Birth', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'DOB_Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of Debtors FirstName', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'FirstName_Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of ID1 from master', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'ID1_Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of ID2 from master', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'ID2_Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of Debtors LastName', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'LastName_Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of Debtors Home Phone', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'Phone_Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence number of debtor ', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'Seq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of Debtors SSN', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'SSN_Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of Debtors Address line 1', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'Street_Hash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Derived hash key of Debtors Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'Linking_HashData', 'COLUMN', N'ZipCode_Hash'
GO
