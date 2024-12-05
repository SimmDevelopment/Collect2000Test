CREATE TABLE [dbo].[AIM_Constraint]
(
[ConstraintId] [int] NOT NULL IDENTITY(1, 1),
[AgencyId] [int] NULL,
[ConstraintType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Operand] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Operator] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Conditions] [image] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Constraint] ADD CONSTRAINT [PK_Constraint] PRIMARY KEY CLUSTERED ([ConstraintId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Constraint] ADD CONSTRAINT [AIM_FK_Constraint_Agency] FOREIGN KEY ([AgencyId]) REFERENCES [dbo].[AIM_Agency] ([AgencyId]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'associated agency id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Constraint', 'COLUMN', N'AgencyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Constraint', 'COLUMN', N'ConstraintId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'what type of constraint', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Constraint', 'COLUMN', N'ConstraintType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the operand of the constraint', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Constraint', 'COLUMN', N'Operand'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the operator of the constraint', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Constraint', 'COLUMN', N'Operator'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the value evaluated for the constraint', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Constraint', 'COLUMN', N'Value'
GO
