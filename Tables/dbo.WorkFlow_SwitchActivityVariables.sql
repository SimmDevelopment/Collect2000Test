CREATE TABLE [dbo].[WorkFlow_SwitchActivityVariables]
(
[ExecID] [uniqueidentifier] NOT NULL,
[ConditionActivityID] [uniqueidentifier] NOT NULL,
[AccountID] [int] NOT NULL,
[Variable] [sql_variant] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkFlow_SwitchActivityVariables] ADD CONSTRAINT [pk_WorkFlow_SwitchActivityVariable] PRIMARY KEY NONCLUSTERED ([ExecID], [ConditionActivityID], [AccountID]) ON [PRIMARY]
GO
