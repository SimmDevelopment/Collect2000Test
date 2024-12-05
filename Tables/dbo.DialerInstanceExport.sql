CREATE TABLE [dbo].[DialerInstanceExport]
(
[dialinstex_key] [int] NOT NULL IDENTITY(1, 1),
[UID] [int] NULL,
[TargetType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DialerIns__Targe__31E7DAE6] DEFAULT ('F'),
[Ordering] [int] NOT NULL,
[FieldName] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ImportTag] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Formatting] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImportCodes] [varchar] (1536) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerInstanceExport] ADD CONSTRAINT [PK_DialerInstanceExport] PRIMARY KEY CLUSTERED ([dialinstex_key]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DialerInstanceExport_1] ON [dbo].[DialerInstanceExport] ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerInstanceExport] ADD CONSTRAINT [UQ_DialerInstanceExport_2] UNIQUE NONCLUSTERED ([UID], [TargetType], [FieldName]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DialerInstanceExport] ADD CONSTRAINT [FK_DialerInstanceExport_1] FOREIGN KEY ([UID]) REFERENCES [dbo].[DialerInstance] ([UID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains definitions of export formats used by ListBuilder to generate files.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Key, unique identity value.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', 'COLUMN', N'dialinstex_key'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of field in target file or target database.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', 'COLUMN', N'FieldName'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', 'COLUMN', N'FieldName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name value pairs used to format export data.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', 'COLUMN', N'Formatting'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Custom values used for extensibility.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', 'COLUMN', N'ImportCodes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field or alias from ListBuilder query. Can also be special code handled internally.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', 'COLUMN', N'ImportTag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order that value is placed in export. Need not be consecutive.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', 'COLUMN', N'Ordering'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Applies to: F=File; D=Database; A=All (both file and database);', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', 'COLUMN', N'TargetType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to DialerInstance UID field. If null then used as Latitude Generic export.', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'DialerInstanceExport', 'COLUMN', N'UID'
GO
