CREATE TABLE [dbo].[imagefiles]
(
[id] [uniqueidentifier] NOT NULL,
[data] [image] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[imagefiles] ADD CONSTRAINT [pk_imagefiles] PRIMARY KEY NONCLUSTERED ([id]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table used to encrypt sensitive data', 'SCHEMA', N'dbo', 'TABLE', N'imagefiles', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Encrypted Data', 'SCHEMA', N'dbo', 'TABLE', N'imagefiles', 'COLUMN', N'data'
GO
EXEC sp_addextendedproperty N'MS_Description', N'UniqueIdentifier of encrypted record.', 'SCHEMA', N'dbo', 'TABLE', N'imagefiles', 'COLUMN', N'id'
GO
