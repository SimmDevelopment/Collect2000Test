CREATE TABLE [dbo].[cbr_metro2_files]
(
[fileID] [int] NOT NULL IDENTITY(1, 1),
[fileName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateCreated] [datetime] NULL,
[userName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cbr_metro2_files] ADD CONSTRAINT [PK_cbr_metro2_files] PRIMARY KEY CLUSTERED ([fileID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Historical table containing Name and location of report generated.  Parent to cbr_metro2_accounts.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_files', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date report created.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_files', 'COLUMN', N'dateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identity key', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_files', 'COLUMN', N'fileID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'File path of generated report.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_files', 'COLUMN', N'fileName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon generating report.', 'SCHEMA', N'dbo', 'TABLE', N'cbr_metro2_files', 'COLUMN', N'userName'
GO
