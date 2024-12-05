CREATE TABLE [dbo].[Linking_DoNotLink]
(
[Source] [int] NOT NULL,
[Target] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Linking_DoNotLink] ADD CONSTRAINT [pk_Linking_DoNotLink] PRIMARY KEY NONCLUSTERED ([Source], [Target]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table retains accounts that have been set to Do Not Link', 'SCHEMA', N'dbo', 'TABLE', N'Linking_DoNotLink', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Source Account Filenumber ID', 'SCHEMA', N'dbo', 'TABLE', N'Linking_DoNotLink', 'COLUMN', N'Source'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Target Filenumber ID', 'SCHEMA', N'dbo', 'TABLE', N'Linking_DoNotLink', 'COLUMN', N'Target'
GO
