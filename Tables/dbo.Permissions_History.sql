CREATE TABLE [dbo].[Permissions_History]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PermissionID] [int] NOT NULL,
[RoleID] [int] NOT NULL,
[NewValue] [bit] NOT NULL,
[SetBy_UserID] [int] NOT NULL,
[DateSet] [datetime] NOT NULL
) ON [PRIMARY]
GO
