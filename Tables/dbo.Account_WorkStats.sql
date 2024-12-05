CREATE TABLE [dbo].[Account_WorkStats]
(
[AccountID] [int] NOT NULL,
[Morning_DW] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Morning_DW] DEFAULT (0),
[Afternoon_DW] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Afternoon_DW] DEFAULT (0),
[Evening_DW] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Evening_DW] DEFAULT (0),
[Weekend_DW] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Weekend_DW] DEFAULT (0),
[Morning_DC] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Morning_DC] DEFAULT (0),
[Afternoon_DC] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Afternoon_DC] DEFAULT (0),
[Evening_DC] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Evening_DC] DEFAULT (0),
[Weekend_DC] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Weekend_DC] DEFAULT (0),
[Morning_MW] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Morning_MW] DEFAULT (0),
[Afternoon_MW] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Afternoon_MW] DEFAULT (0),
[Evening_MW] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Evening_MW] DEFAULT (0),
[Weekend_MW] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Weekend_MW] DEFAULT (0),
[Morning_MC] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Morning_MC] DEFAULT (0),
[Afternoon_MC] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Afternoon_MC] DEFAULT (0),
[Evening_MC] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Evening_MC] DEFAULT (0),
[Weekend_MC] [smallint] NOT NULL CONSTRAINT [DF_Account_WorkStats_Weekend_MC] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account_WorkStats] ADD CONSTRAINT [PK_Account_WorkStats] PRIMARY KEY CLUSTERED ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table retaining total accounts worked and contacted', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Account FileNumber', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Dialer Contacted Accounts Afternoon Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Afternoon_DC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Dialer Worked Accounts Afternoon Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Afternoon_DW'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Manually Contacted Accounts Afternoon Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Afternoon_MC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Manually Worked Accounts Afternoon Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Afternoon_MW'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Dialer Contacted Accounts Evening Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Evening_DC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Dialer Worked Accounts Evening Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Evening_DW'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Manually Contacted Accounts Evening Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Evening_MC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Manually Worked Accounts Evening Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Evening_MW'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Dialer Contacted Accounts Morning Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Morning_DC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Dialer Worked Accounts Morning Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Morning_DW'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Manually Contacted Accounts Morning Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Morning_MC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Manually Worked Accounts Morning Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Morning_MW'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Dialer Contacted Accounts Weekend Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Weekend_DC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Dialer Worked Accounts Weekend Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Weekend_DW'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Manually Contacted Accounts Weekend Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Weekend_MC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Manually Worked Accounts Weekend Hours', 'SCHEMA', N'dbo', 'TABLE', N'Account_WorkStats', 'COLUMN', N'Weekend_MW'
GO
