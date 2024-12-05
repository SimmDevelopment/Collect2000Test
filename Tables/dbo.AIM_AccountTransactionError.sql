CREATE TABLE [dbo].[AIM_AccountTransactionError]
(
[AccountTransactionErrorId] [int] NOT NULL IDENTITY(1, 1),
[AccountReferenceId] [int] NULL,
[BatchFileHistoryId] [int] NULL,
[TransactionTypeId] [int] NULL,
[TransactionContext] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionStatusTypeId] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDateTime] [datetime] NULL,
[CompletedDateTime] [datetime] NULL,
[AgencyId] [int] NULL,
[LogMessageId] [int] NULL,
[Tier] [int] NULL,
[CommissionPercentage] [float] NULL,
[Balance] [money] NULL,
[PaymentBatchNumber] [int] NULL,
[RecallReasonCodeId] [int] NULL,
[Comment] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ValidPlacement] [bit] NULL CONSTRAINT [DF__AIM_Accou__Valid__65BC84A7] DEFAULT ((1)),
[FeeSchedule] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForeignTableUniqueID] [int] NULL
) ON [PRIMARY]
GO
