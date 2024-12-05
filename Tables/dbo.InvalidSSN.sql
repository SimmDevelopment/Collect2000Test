CREATE TABLE [dbo].[InvalidSSN]
(
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table used to track invalid SSN numbers', 'SCHEMA', N'dbo', 'TABLE', N'InvalidSSN', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invalid social security number', 'SCHEMA', N'dbo', 'TABLE', N'InvalidSSN', 'COLUMN', N'SSN'
GO
