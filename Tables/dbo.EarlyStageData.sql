CREATE TABLE [dbo].[EarlyStageData]
(
[AccountID] [int] NOT NULL,
[PaymentHistory] [char] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentMinDue] [money] NULL,
[CurrentDue] [money] NULL,
[Current30] [money] NULL,
[Current60] [money] NULL,
[Current90] [money] NULL,
[Current120] [money] NULL,
[Current150] [money] NULL,
[Current180] [money] NULL,
[StatementMinDue] [money] NULL,
[StatementDue] [money] NULL,
[Statement30] [money] NULL,
[Statement60] [money] NULL,
[Statement90] [money] NULL,
[Statement120] [money] NULL,
[Statement150] [money] NULL,
[Statement180] [money] NULL,
[PromoIndicator] [char] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoExpDate] [datetime] NULL,
[SubStatuses] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestRate] [money] NULL,
[FixedInterestFlag] [bit] NULL,
[FixedMinPayment] [money] NULL,
[MultipleAccounts] [int] NULL,
[AROwner] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanCode] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProviderType] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LateFeeFlag] [bit] NULL,
[LateFeeAccessed] [char] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForceCBFlag] [bit] NULL,
[MailToCoApp] [bit] NULL,
[FirstPaymentDefault] [bit] NULL,
[CycleCode] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CyclePreviousBegin] [datetime] NULL,
[CyclePreviousDue] [datetime] NULL,
[CyclePreviousLate] [datetime] NULL,
[CyclePreviousEnd] [datetime] NULL,
[CycleCurrentBegin] [datetime] NULL,
[CycleCurrentDue] [datetime] NULL,
[CycleCurrentLate] [datetime] NULL,
[CycleCurrentEnd] [datetime] NULL,
[CycleNextBegin] [datetime] NULL,
[CycleNextDue] [datetime] NULL,
[CycleNextLate] [datetime] NULL,
[CycleNextEnd] [datetime] NULL,
[EFT] [bit] NULL,
[MultipleProviders] [bit] NULL,
[CollectorDesk] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EarlyStageData] ADD CONSTRAINT [pk_EarlyStageData] PRIMARY KEY CLUSTERED ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EarlyStageData] WITH NOCHECK ADD CONSTRAINT [fk_EarlyStageData_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'NOT USED>        The earlystage table contains delinquency information on an account for use in a first-party pre-charge off environment. This information is read-only and must be populated using a special interface (custom programming).', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'AROwner'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CollectorDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Current120'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Current150'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Current180'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Current30'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Current60'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Current90'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CurrentDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CurrentMinDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CycleCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CycleCurrentBegin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CycleCurrentDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CycleCurrentEnd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CycleCurrentLate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CycleNextBegin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CycleNextDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CycleNextEnd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CycleNextLate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CyclePreviousBegin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CyclePreviousDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CyclePreviousEnd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'CyclePreviousLate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'EFT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'FirstPaymentDefault'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'FixedInterestFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'FixedMinPayment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'ForceCBFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'InterestRate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'LateFeeAccessed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'LateFeeFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'MailToCoApp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'MultipleAccounts'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'MultipleProviders'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'PaymentHistory'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'PlanCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'PromoExpDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'PromoIndicator'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'ProviderType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Statement120'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Statement150'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Statement180'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Statement30'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Statement60'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'Statement90'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'StatementDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'StatementMinDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'EarlyStageData', 'COLUMN', N'SubStatuses'
GO
