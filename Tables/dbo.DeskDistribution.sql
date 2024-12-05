CREATE TABLE [dbo].[DeskDistribution]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Desk Distribution table is used to set up default desks (inventory) to hold accounts to disburse with the Desk Distributor program. Customer accounts may be distributed to multiple desks, based on the State (address) and account balance', 'SCHEMA', N'dbo', 'TABLE', N'DeskDistribution', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'DeskDistribution', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'DeskDistribution', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State of Accounts', 'SCHEMA', N'dbo', 'TABLE', N'DeskDistribution', 'COLUMN', N'State'
GO
