CREATE TABLE [dbo].[Reports_Favorites]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[ReportID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reports_Favorites] ADD CONSTRAINT [PK_Reports_Favorites] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reports_Favorites] ADD CONSTRAINT [FK_Reports_Favorites_Reports_Master] FOREIGN KEY ([ReportID]) REFERENCES [dbo].[Reports_Master] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reports_Favorites] ADD CONSTRAINT [FK_Reports_Favorites_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID from Reports_Master to identify the report that was saved as a favorite for the user', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Favorites', 'COLUMN', N'ReportID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID from Users table that identifies the user that saved the report as a favorite', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Favorites', 'COLUMN', N'UserID'
GO
