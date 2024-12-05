CREATE TABLE [dbo].[LionUserMenus]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[LionUserId] [int] NULL,
[LionMenuId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionUserMenus] ADD CONSTRAINT [PK_LionUserMenus] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionUserMenus] ADD CONSTRAINT [FK_LionUserMenus_LionMenus] FOREIGN KEY ([LionMenuId]) REFERENCES [dbo].[LionMenus] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LionUserMenus] ADD CONSTRAINT [FK_LionUserMenus_LionUsers] FOREIGN KEY ([LionUserId]) REFERENCES [dbo].[LionUsers] ([ID]) ON DELETE CASCADE
GO
