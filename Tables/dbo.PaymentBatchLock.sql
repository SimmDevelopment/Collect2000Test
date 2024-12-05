CREATE TABLE [dbo].[PaymentBatchLock]
(
[LockId] [int] NOT NULL IDENTITY(1, 1),
[BatchNumber] [int] NOT NULL,
[UserName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Expire] [datetime] NOT NULL,
[Application] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MachineName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LockType] [int] NOT NULL,
[PaymentId] [int] NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__PaymentBa__Creat__7A4D8D39] DEFAULT (getdate()),
[ChangedByOthers] [bit] NOT NULL CONSTRAINT [DF__PaymentBa__Chang__7B41B172] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentBatchLock] ADD CONSTRAINT [PK_PaymentBatchLock] PRIMARY KEY CLUSTERED ([LockId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Global Library that created batch', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchLock', 'COLUMN', N'Application'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Batches ID from PaymentBatches Table', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchLock', 'COLUMN', N'BatchNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'May the lock be changed by others Bit field', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchLock', 'COLUMN', N'ChangedByOthers'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date item created', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchLock', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Lock will expire', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchLock', 'COLUMN', N'Expire'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identifier for each record', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchLock', 'COLUMN', N'LockId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of Lock', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchLock', 'COLUMN', N'LockType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Machine Name of item that created lock', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchLock', 'COLUMN', N'MachineName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'payment id ', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchLock', 'COLUMN', N'PaymentId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Name who  created the lock', 'SCHEMA', N'dbo', 'TABLE', N'PaymentBatchLock', 'COLUMN', N'UserName'
GO
