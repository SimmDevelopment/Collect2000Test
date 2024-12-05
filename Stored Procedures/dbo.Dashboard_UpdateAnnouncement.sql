SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Dashboard_UpdateAnnouncement]
	@Created datetime, @Title varchar(50), @Announcement varchar(250), @AnnouncementID int
AS
BEGIN
  UPDATE Announcements SET Created=@Created, Title=@Title, Announcement=@Announcement
  WHERE AnnouncementID=@AnnouncementID
END
GO
