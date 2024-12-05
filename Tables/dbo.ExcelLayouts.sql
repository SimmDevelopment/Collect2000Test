CREATE TABLE [dbo].[ExcelLayouts]
(
[LayoutName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Seq] [int] NOT NULL,
[DataMap] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DataControl] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used with Import Excel to save excel mapping layouts for importing data', 'SCHEMA', N'dbo', 'TABLE', N'ExcelLayouts', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Column name ', 'SCHEMA', N'dbo', 'TABLE', N'ExcelLayouts', 'COLUMN', N'DataMap'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined name of saved layout', 'SCHEMA', N'dbo', 'TABLE', N'ExcelLayouts', 'COLUMN', N'LayoutName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence number (column number)', 'SCHEMA', N'dbo', 'TABLE', N'ExcelLayouts', 'COLUMN', N'Seq'
GO
