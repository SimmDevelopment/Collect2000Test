CREATE TABLE [dbo].[LetterRoles]
(
[LetterRoleID] [int] NOT NULL IDENTITY(1, 1),
[LetterID] [int] NOT NULL,
[RoleID] [int] NOT NULL,
[DateCreated] [datetime] NOT NULL CONSTRAINT [DF_LetterRoles_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NOT NULL CONSTRAINT [DF_LetterRoles_DateUpdated] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterRoles] ADD CONSTRAINT [PK_LetterRoles] PRIMARY KEY CLUSTERED ([LetterRoleID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LetterRoles] ADD CONSTRAINT [FK_LetterRoles_letter] FOREIGN KEY ([LetterID]) REFERENCES [dbo].[letter] ([LetterID])
GO
ALTER TABLE [dbo].[LetterRoles] ADD CONSTRAINT [FK_LetterRoles_Roles] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[Roles] ([ID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Security options are set for each Letter Template, and are based on a users assgned role within Latitude.  This table is used by the ALLOWED ROLES window of the Letter Console to assign security roles to letters.', 'SCHEMA', N'dbo', 'TABLE', N'LetterRoles', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp created', 'SCHEMA', N'dbo', 'TABLE', N'LetterRoles', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'LetterRoles', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter Identity ID', 'SCHEMA', N'dbo', 'TABLE', N'LetterRoles', 'COLUMN', N'LetterID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter Role Identity Key ID', 'SCHEMA', N'dbo', 'TABLE', N'LetterRoles', 'COLUMN', N'LetterRoleID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Role Identity ID.  Only users having the respective role will be allowed to select this letter', 'SCHEMA', N'dbo', 'TABLE', N'LetterRoles', 'COLUMN', N'RoleID'
GO
