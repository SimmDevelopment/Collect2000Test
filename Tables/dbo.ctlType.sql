CREATE TABLE [dbo].[ctlType]
(
[ctl] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tableName] [sys].[sysname] NOT NULL,
[description] [sys].[sysname] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ctlType] ADD CONSTRAINT [PK_ctlType] PRIMARY KEY CLUSTERED ([ctl]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
