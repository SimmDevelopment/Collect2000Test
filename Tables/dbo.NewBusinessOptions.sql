CREATE TABLE [dbo].[NewBusinessOptions]
(
[NewBusinessOptionsID] [int] NOT NULL IDENTITY(1, 1),
[CustomerID] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllowZipcodeEntry] [bit] NULL,
[SkipExtraData] [bit] NULL,
[SkipMiscExtraData] [bit] NULL,
[AutoZip] [bit] NULL,
[MultipleFieldSchedules] [bit] NULL,
[LinkOnSsn] [bit] NULL,
[AllowDupeCustomerAccount] [bit] NULL,
[SkipDates] [bit] NULL,
[FieldWorkPhone] [bit] NULL,
[FieldFax] [bit] NULL,
[FieldEmail] [bit] NULL,
[FieldPager] [bit] NULL,
[FieldDriverLicense] [bit] NULL,
[FieldSsn] [bit] NULL,
[FieldInterestRateAndDate] [bit] NULL,
[FieldDob] [bit] NULL,
[FieldUserDate1] [bit] NULL,
[FieldUserDate2] [bit] NULL,
[FieldUserDate3] [bit] NULL,
[FieldDelinqDate] [bit] NULL,
[FieldBucket2] [bit] NULL,
[FieldBucket3] [bit] NULL,
[FieldBucket4] [bit] NULL,
[FieldBucket5] [bit] NULL,
[FieldBucket6] [bit] NULL,
[FieldBucket7] [bit] NULL,
[FieldBucket8] [bit] NULL,
[FieldBucket9] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NewBusinessOptions] ADD CONSTRAINT [PK_NewBusinessOptions] PRIMARY KEY CLUSTERED ([NewBusinessOptionsID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_NewBusinessOptions_CustomerID] ON [dbo].[NewBusinessOptions] ([CustomerID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
