CREATE TABLE [dbo].[UserMenus]
(
[UserMenuID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[MenuGUID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
