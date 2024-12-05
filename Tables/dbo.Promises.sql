CREATE TABLE [dbo].[Promises]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Entered] [datetime] NULL,
[DueDate] [datetime] NULL,
[AcctID] [int] NULL,
[DebtorID] [tinyint] NULL,
[Amount] [money] NULL,
[Desk] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendRM] [bit] NULL,
[PromiseMode] [tinyint] NULL,
[LetterCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FutureUID] [int] NULL,
[SendRMDate] [datetime] NULL,
[RMSentDate] [datetime] NULL,
[Suspended] [bit] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF__Promises__Active__5D378935] DEFAULT (1),
[Kept] [bit] NULL,
[DateCreated] [datetime] NULL CONSTRAINT [def_Promises_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NULL CONSTRAINT [def_Promises_DateUpdated] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArrangementID] [int] NULL,
[PaymentLinkUID] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Promises_DateStamps]
ON [dbo].[Promises]
FOR UPDATE
AS

UPDATE dbo.Promises
	SET DateUpdated = GETDATE()
FROM dbo.Promises
INNER JOIN INSERTED
ON Promises.ID = INSERTED.ID;

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_Promises_WorkFlow_SystemEvents]
ON [dbo].[Promises]
FOR INSERT
AS

CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID], [EventVariable])
SELECT [INSERTED].[AcctID], CAST(NULL AS SQL_VARIANT)
FROM [INSERTED]
WHERE NOT EXISTS (
	SELECT *
	FROM [dbo].[Promises]
	WHERE [Promises].[AcctID] = [INSERTED].[AcctID]
	AND [Promises].[ID] <> [INSERTED].[ID]
	AND [Promises].[Active] = 1
);

IF EXISTS (SELECT * FROM #EventAccounts) BEGIN
	EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Promise Entered', @CreateNew = 0;

	TRUNCATE TABLE #EventAccounts;
END;

DROP TABLE #EventAccounts;

RETURN;

GO
ALTER TABLE [dbo].[Promises] ADD CONSTRAINT [PK_Promises] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Promises_AcctID] ON [dbo].[Promises] ([AcctID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Promises_ArrangementID] ON [dbo].[Promises] ([ArrangementID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Promises_Desk] ON [dbo].[Promises] ([Desk]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Promises_DueDate] ON [dbo].[Promises] ([DueDate]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_promises_PaymentLinkUID] ON [dbo].[Promises] ([PaymentLinkUID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber - Master.Number', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'AcctID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator specifying promise is pending', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount of promise', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User or manager approving promise', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'ApprovedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'user ID of user creating promise', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customr code account belongs to', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date promise created in system', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date promise was last updated', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account DebtorID - Debtors.DebtorID', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk of collector generating promise', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date payment is due', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'DueDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date promise entered into system ', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'Entered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Auto generated unique identity ', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'indicator specifying promise was kept', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'Kept'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined letter code for promise letter', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'LetterCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Virtual Key to link all the related payment items together.', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'PaymentLinkUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 - Single Payment,2 - Monthly Payments,3 - Bi-Weekly Payments,4 - Twice a Month, 5 - Weekly, 6 - Settlement, 7 - MultipartSettlement, 8 - PayOff, 9 - Every28Days, 10 - EndOfMonth,  11 - BiMonthly, 12 - LastFriday, 99 - Multiple ', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'PromiseMode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reminder letter sent date', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'RMSentDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator to send reminder letter', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'SendRM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reminder letter send date', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'SendRMDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Promise suspended due to broken promise or NSF', 'SCHEMA', N'dbo', 'TABLE', N'Promises', 'COLUMN', N'Suspended'
GO
