CREATE TABLE [dbo].[ShermanBalanceUpdate]
(
[FileName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AcctID] [int] NULL,
[Account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number] [int] NULL,
[DateRan] [datetime] NULL,
[EffectiveDate] [datetime] NULL,
[CurrBalance] [money] NULL,
[PrinCollected] [money] NULL,
[PrinOwing] [money] NULL,
[AttyFeeCollected] [money] NULL,
[AttyFeeOwing] [money] NULL,
[InterestCollected] [money] NULL,
[InterestOwing] [money] NULL,
[MiscExtraCollected] [money] NULL,
[MiscExtraOwing] [money] NULL,
[AccrualMethod] [money] NULL,
[InterestRate] [money] NULL,
[DailyInterestAccrual] [money] NULL,
[SuspendedInterest] [money] NULL,
[LastPmtDate] [datetime] NULL,
[LastPmtAmt] [money] NULL,
[LastNSFDate] [datetime] NULL,
[LastNSFAmt] [money] NULL,
[Processed] [bit] NULL CONSTRAINT [DF__ShermanBa__Proce__2606462E] DEFAULT (0),
[UID] [int] NOT NULL IDENTITY(1, 1),
[BatchNumber] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ShermanBalanceUpdate] ADD CONSTRAINT [PK_ShermanBalanceUpdate] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_ShermanBalanceUpdate_Account] ON [dbo].[ShermanBalanceUpdate] ([Account]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_ShermanBalanceUpdate_BatchNumber] ON [dbo].[ShermanBalanceUpdate] ([BatchNumber]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_ShermanBalanceUpdate_DateRan] ON [dbo].[ShermanBalanceUpdate] ([DateRan]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_ShermanBalanceUpdate_FileName] ON [dbo].[ShermanBalanceUpdate] ([FileName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_ShermanBalanceUpdate_Number] ON [dbo].[ShermanBalanceUpdate] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
