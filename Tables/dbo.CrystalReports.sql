CREATE TABLE [dbo].[CrystalReports]
(
[filename] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrystalReportImage] [image] NULL,
[FileDate] [datetime] NULL,
[IsCustom] [bit] NULL CONSTRAINT [DF__CrystalRe__IsCus__37861642] DEFAULT (0)
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Retains crystal reports imported to latitude and available form the reports menu.', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Actual image xeecuted by latitude', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', 'COLUMN', N'CrystalReportImage'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', 'COLUMN', N'CrystalReportImage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descritpion of report', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of import', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', 'COLUMN', N'FileDate'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', 'COLUMN', N'FileDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Filename of report image', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', 'COLUMN', N'filename'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', 'COLUMN', N'filename'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Designates Core vs. Custom report.', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', 'COLUMN', N'IsCustom'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'CrystalReports', 'COLUMN', N'IsCustom'
GO
