CREATE TABLE [dbo].[AIM_AccountTransaction]
(
[AccountTransactionId] [int] NOT NULL IDENTITY(1, 1),
[AccountReferenceId] [int] NULL,
[BatchFileHistoryId] [int] NULL,
[TransactionTypeId] [int] NULL,
[TransactionContext] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionStatusTypeId] [int] NULL,
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
[ValidPlacement] [bit] NOT NULL CONSTRAINT [DF__AIM_Accou__Valid__0A2EEF47] DEFAULT ((1)),
[FeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForeignTableUniqueID] [bigint] NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Balance1] [money] NULL CONSTRAINT [DF__AIM_AccountTransaction__Balance1] DEFAULT ((0)),
[Balance2] [money] NULL CONSTRAINT [DF__AIM_AccountTransaction__Balance2] DEFAULT ((0)),
[Balance3] [money] NULL CONSTRAINT [DF__AIM_AccountTransaction__Balance3] DEFAULT ((0)),
[Balance4] [money] NULL CONSTRAINT [DF__AIM_AccountTransaction__Balance4] DEFAULT ((0)),
[Balance5] [money] NULL CONSTRAINT [DF__AIM_AccountTransaction__Balance5] DEFAULT ((0)),
[Balance6] [money] NULL CONSTRAINT [DF__AIM_AccountTransaction__Balance6] DEFAULT ((0)),
[Balance7] [money] NULL CONSTRAINT [DF__AIM_AccountTransaction__Balance7] DEFAULT ((0)),
[Balance8] [money] NULL CONSTRAINT [DF__AIM_AccountTransaction__Balance8] DEFAULT ((0)),
[Balance9] [money] NULL CONSTRAINT [DF__AIM_AccountTransaction__Balance9] DEFAULT ((0)),
[PlacedEquipmentCount] [int] NULL CONSTRAINT [DF__AIM_AccountTransaction__PlacedEquipmentCount] DEFAULT ((0)),
[PlacedEquipmentValue] [money] NULL CONSTRAINT [DF__AIM_AccountTransaction__PlacedEquipmentValue] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_AccountTransaction] ADD CONSTRAINT [PK_AccountTransaction] PRIMARY KEY CLUSTERED ([AccountTransactionId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AIM_AccountTransaction_AccountReferenceId] ON [dbo].[AIM_AccountTransaction] ([AccountReferenceId], [TransactionTypeId]) INCLUDE ([TransactionStatusTypeId], [ValidPlacement]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AIM_AccountTransaction_1] ON [dbo].[AIM_AccountTransaction] ([BatchFileHistoryId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AIM_AccountTransaction_TransactionType] ON [dbo].[AIM_AccountTransaction] ([TransactionTypeId], [TransactionStatusTypeId], [AgencyId]) INCLUDE ([AccountReferenceId], [ValidPlacement]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_AccountTransaction] ADD CONSTRAINT [AIM_FK_AccountTransaction_AccountReference] FOREIGN KEY ([AccountReferenceId]) REFERENCES [dbo].[AIM_AccountReference] ([AccountReferenceId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AIM_AccountTransaction] ADD CONSTRAINT [AIM_FK_AccountTransaction_Agency] FOREIGN KEY ([AgencyId]) REFERENCES [dbo].[AIM_Agency] ([AgencyId])
GO
ALTER TABLE [dbo].[AIM_AccountTransaction] ADD CONSTRAINT [AIM_FK_AccountTransaction_LogMessage] FOREIGN KEY ([LogMessageId]) REFERENCES [dbo].[AIM_LogMessage] ([LogMessageId])
GO
ALTER TABLE [dbo].[AIM_AccountTransaction] ADD CONSTRAINT [AIM_FK_AccountTransaction_RecallReasonCode] FOREIGN KEY ([RecallReasonCodeId]) REFERENCES [dbo].[AIM_RecallReasonCode] ([RecallReasonCodeId])
GO
ALTER TABLE [dbo].[AIM_AccountTransaction] ADD CONSTRAINT [AIM_FK_AccountTransaction_TransactionStatusType] FOREIGN KEY ([TransactionStatusTypeId]) REFERENCES [dbo].[AIM_TransactionStatusType] ([TransactionStatusTypeId])
GO
ALTER TABLE [dbo].[AIM_AccountTransaction] ADD CONSTRAINT [AIM_FK_AccountTransaction_TransactionType] FOREIGN KEY ([TransactionTypeId]) REFERENCES [dbo].[AIM_TransactionType] ([TransactionTypeId]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated account reference record', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'AccountReferenceId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'AccountTransactionId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated agency for this transaction', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'AgencyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the current balance of the account', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'Balance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the batch file history id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'BatchFileHistoryId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free form comments', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the commission percentage for this transaction', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'CommissionPercentage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date completed', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'CompletedDateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date created', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'CreatedDateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the log message (error message or success)', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'LogMessageId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the latitude payment batch number if applicable', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'PaymentBatchNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the recall reason code id if applicable', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'RecallReasonCodeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the current tier', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'Tier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the raw data sent or received in the file for this record', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'TransactionContext'
GO
EXEC sp_addextendedproperty N'MS_Description', N'status of this transaction (Pending, Complete, Processing ,etc', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'TransactionStatusTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the type of transaction', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'TransactionTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'for placements only, flag if it is still a valid placement', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AccountTransaction', 'COLUMN', N'ValidPlacement'
GO
