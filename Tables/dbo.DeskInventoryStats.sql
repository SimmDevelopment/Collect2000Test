CREATE TABLE [dbo].[DeskInventoryStats]
(
[desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SysYear] [int] NULL,
[SysMonth] [int] NULL,
[customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewNumberIn] [int] NULL,
[NewAmtIn] [money] NULL,
[OtherNumberIn] [int] NULL,
[OtherAmtIn] [money] NULL,
[NumberOut] [int] NULL,
[AmtOut] [money] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table that tracks total accounts and amounts that have been allocated and deallocated to respective desk for a given period or billing cycle.', 'SCHEMA', N'dbo', 'TABLE', N'DeskInventoryStats', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total current balance of accounts moved out of desk', 'SCHEMA', N'dbo', 'TABLE', N'DeskInventoryStats', 'COLUMN', N'AmtOut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'DeskInventoryStats', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Code of Desk', 'SCHEMA', N'dbo', 'TABLE', N'DeskInventoryStats', 'COLUMN', N'desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Amount placed for New Business', 'SCHEMA', N'dbo', 'TABLE', N'DeskInventoryStats', 'COLUMN', N'NewAmtIn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total new business or inventory accounts added to desk', 'SCHEMA', N'dbo', 'TABLE', N'DeskInventoryStats', 'COLUMN', N'NewNumberIn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total accounts moved out of desk', 'SCHEMA', N'dbo', 'TABLE', N'DeskInventoryStats', 'COLUMN', N'NumberOut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount placed for Non Inventory accounts', 'SCHEMA', N'dbo', 'TABLE', N'DeskInventoryStats', 'COLUMN', N'OtherAmtIn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Non inventory accounts moved to desk', 'SCHEMA', N'dbo', 'TABLE', N'DeskInventoryStats', 'COLUMN', N'OtherNumberIn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Billing Cycle Month', 'SCHEMA', N'dbo', 'TABLE', N'DeskInventoryStats', 'COLUMN', N'SysMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Billing Cycle Year', 'SCHEMA', N'dbo', 'TABLE', N'DeskInventoryStats', 'COLUMN', N'SysYear'
GO
