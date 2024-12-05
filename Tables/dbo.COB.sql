CREATE TABLE [dbo].[COB]
(
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Class of Business, used to group the type of company each of your clients represents and can be noted at the Customer and account levels', 'SCHEMA', N'dbo', 'TABLE', N'COB', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined Class of Businees code', 'SCHEMA', N'dbo', 'TABLE', N'COB', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Class Descritpion', 'SCHEMA', N'dbo', 'TABLE', N'COB', 'COLUMN', N'Description'
GO
