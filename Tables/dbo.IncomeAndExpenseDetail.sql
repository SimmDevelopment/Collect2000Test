CREATE TABLE [dbo].[IncomeAndExpenseDetail]
(
[IncomeAndExpenseDetailID] [int] NOT NULL IDENTITY(1, 1),
[IncomeAndExpenseID] [int] NOT NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [money] NOT NULL CONSTRAINT [DF_IncomeAndExpenseDetail_Value] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IncomeAndExpenseDetail] ADD CONSTRAINT [PK_IncomeAndExpenseDetail] PRIMARY KEY CLUSTERED ([IncomeAndExpenseDetailID]) ON [PRIMARY]
GO
