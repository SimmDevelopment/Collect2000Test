CREATE TABLE [dbo].[IncomeAndExpense]
(
[IncomeAndExpenseID] [int] NOT NULL IDENTITY(1, 1),
[LastUpdated] [datetime] NOT NULL CONSTRAINT [DF_IncomeAndExpense_LastUpdated] DEFAULT (getutcdate()),
[AccountID] [int] NOT NULL,
[MonthlyDisposableIncome] [money] NOT NULL CONSTRAINT [DF_IncomeAndExpense_MonthlyDisposableIncome] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_IncomeAndExpense_WorkFlow_SystemEvents_Updated] ON [dbo].[IncomeAndExpense]
    FOR UPDATE
AS
    CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID])
SELECT [INSERTED].[AccountId]
FROM [INSERTED];

EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Income and Expenses Updated', @CreateNew = 0;

DROP TABLE #EventAccounts;

RETURN;
                                     
GO
ALTER TABLE [dbo].[IncomeAndExpense] ADD CONSTRAINT [PK_IncomeAndExpense] PRIMARY KEY CLUSTERED ([IncomeAndExpenseID]) ON [PRIMARY]
GO
