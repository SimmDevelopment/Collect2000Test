CREATE TABLE [dbo].[ImportExcel]
(
[Code] [int] NULL,
[DESCRIPTION] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FieldSeq] [int] NULL,
[FieldData] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table used by Import Excel to map imports to Latitude', 'SCHEMA', N'dbo', 'TABLE', N'ImportExcel', NULL, NULL
GO
