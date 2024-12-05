CREATE TABLE [dbo].[WorkForm_Panels]
(
[UID] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF__WorkForm_Pa__UID__3672C1CF] DEFAULT (newid()),
[Name] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TypeName] [varchar] (260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ControlData] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [bit] NOT NULL CONSTRAINT [DF_WorkForm_Panels_Enabled] DEFAULT (1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkForm_Panels] ADD CONSTRAINT [pk_WorkForm_Panels] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'WorkForm_Panels', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'WorkForm_Panels', 'COLUMN', N'ControlData'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'WorkForm_Panels', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'WorkForm_Panels', 'COLUMN', N'TypeName'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Ignore', 'SCHEMA', N'dbo', 'TABLE', N'WorkForm_Panels', 'COLUMN', N'UID'
GO
