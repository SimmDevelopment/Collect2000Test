CREATE TABLE [dbo].[AccountAndArrangementIds]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[AccountId] [int] NOT NULL,
[PaymentType] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArrangementId] [int] NULL,
[Qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Link] [int] NULL,
[LinkDriver] [int] NULL,
[PlacedOnHold] [bit] NULL,
[HandledQlevelChange] [bit] NULL,
[NextDueDate] [datetime] NULL,
[LinkDriverIsClosed] [bit] NULL,
[NextPaymentType] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NextAmount] [money] NULL,
[NextPaymentTypeForArrangement] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NextAmountForArrangement] [money] NULL,
[NextDueDateForArrangement] [datetime] NULL,
[Reason] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllAccountsAreInArrangement] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AccountAndArrangementIds] ADD CONSTRAINT [PK__AccountA__3214EC074FC7B427] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relates to number in dbo.master table', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'AccountId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag that determines if all accounts are in an arrangement', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'AllAccountsAreInArrangement'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id from dbo.Arrangements table', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'ArrangementId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag for determining if Qlevel was updated', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'HandledQlevelChange'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Key', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link value of dbo.master table record', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'Link'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LinkDriver value of dbo.master table record', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'LinkDriver'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag if the linkdriver is closed or returned', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'LinkDriverIsClosed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next Payment Amount for an arrangement group', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'NextAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next Payment Amount for an arrangement', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'NextAmountForArrangement'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next Due Date for an arrangement group', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'NextDueDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next Due Date for an arrangement', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'NextDueDateForArrangement'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next Payment Type for an arrangement group', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'NextPaymentType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next Payment Type for an arrangement', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'NextPaymentTypeForArrangement'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Payment Type', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'PaymentType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag for updates when payments are set on hold', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'PlacedOnHold'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Qlevel of dbo.master table record', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'Qlevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reason the record is included in the table', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'Reason'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Status of dbo.master table record', 'SCHEMA', N'dbo', 'TABLE', N'AccountAndArrangementIds', 'COLUMN', N'Status'
GO
