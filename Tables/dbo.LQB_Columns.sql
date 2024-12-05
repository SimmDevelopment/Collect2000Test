CREATE TABLE [dbo].[LQB_Columns]
(
[ID] [int] NOT NULL,
[description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[field] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[default] [bit] NOT NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used.  This table contained the columns used by the legacy applications Latitude Funnel', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Columns', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Columns', 'COLUMN', N'default'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Columns', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Columns', 'COLUMN', N'field'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'LQB_Columns', 'COLUMN', N'ID'
GO
