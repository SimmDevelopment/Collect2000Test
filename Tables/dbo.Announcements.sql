CREATE TABLE [dbo].[Announcements]
(
[AnnouncementID] [int] NOT NULL IDENTITY(1, 1),
[Created] [datetime] NOT NULL CONSTRAINT [DF_Announcements_Created] DEFAULT (getdate()),
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Announcement] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TeamID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Announcements] ADD CONSTRAINT [PK_Announcements] PRIMARY KEY CLUSTERED ([AnnouncementID]) ON [PRIMARY]
GO
