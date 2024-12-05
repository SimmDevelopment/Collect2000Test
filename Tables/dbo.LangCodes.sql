CREATE TABLE [dbo].[LangCodes]
(
[Code] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESCRIPTION] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used to assign language codes can then be assigned to a particular Debtor', 'SCHEMA', N'dbo', 'TABLE', N'LangCodes', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Application defined Unique Code', 'SCHEMA', N'dbo', 'TABLE', N'LangCodes', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Language (English, Spanish, French etc.)', 'SCHEMA', N'dbo', 'TABLE', N'LangCodes', 'COLUMN', N'DESCRIPTION'
GO
