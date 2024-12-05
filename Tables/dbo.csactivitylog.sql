CREATE TABLE [dbo].[csactivitylog]
(
[userid] [int] NOT NULL,
[created] [datetime] NOT NULL CONSTRAINT [DF_csactivitylog_created] DEFAULT (getdate()),
[number] [int] NOT NULL,
[description] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_csactivitylog_description] DEFAULT (0)
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used by Latitude.CS', 'SCHEMA', N'dbo', 'TABLE', N'csactivitylog', NULL, NULL
GO
