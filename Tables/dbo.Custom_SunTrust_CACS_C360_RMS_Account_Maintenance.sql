CREATE TABLE [dbo].[Custom_SunTrust_CACS_C360_RMS_Account_Maintenance]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[AgencyId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LocationCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateAssigned] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommPercent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommFlatAmt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmountPlaced] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalDelinqAmt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisputedAmt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalDueAmt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentAmountDue] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestRate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateToBeRecal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastPaymentDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastPaymentAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OverLimitAmt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditLimitAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CyclesDelinquentCount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DaysDelinquent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AsgnLagDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TSRPercent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TSRAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrincipalDelqAmt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServiceCharge] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeOffFee] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChargeOffDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BranchName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LobCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_SunTrust_CACS_C360_RMS_Account_Maintenance] ADD CONSTRAINT [PK_Custom_SunTrust_CACS_C360_RMS_Account_Maintenance] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
