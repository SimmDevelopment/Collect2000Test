CREATE TABLE [dbo].[LQB_Conditions]
(
[ID] [int] NOT NULL,
[pos] [int] NOT NULL,
[field] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [tinyint] NOT NULL,
[description] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[var1] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[var2] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[var3] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used.  This table contained the columns used by the legacy applications Latitude Funnel', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Conditions', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Conditions', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Conditions', 'COLUMN', N'field'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Conditions', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Conditions', 'COLUMN', N'pos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Conditions', 'COLUMN', N'type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Conditions', 'COLUMN', N'var1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Conditions', 'COLUMN', N'var2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Conditions', 'COLUMN', N'var3'
GO
