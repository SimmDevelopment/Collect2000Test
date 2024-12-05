CREATE TABLE [dbo].[LionReportRolesMenus]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ReportRoleId] [int] NULL,
[MenuId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionReportRolesMenus] ADD CONSTRAINT [PK_LionReportRolesMenus] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LionReportRolesMenus] ADD CONSTRAINT [FK_LionReportRolesMenus_LionMenus] FOREIGN KEY ([MenuId]) REFERENCES [dbo].[LionMenus] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LionReportRolesMenus] ADD CONSTRAINT [FK_LionReportRolesMenus_LionReportRoles] FOREIGN KEY ([ReportRoleId]) REFERENCES [dbo].[LionReportRoles] ([ID]) ON DELETE CASCADE
GO
