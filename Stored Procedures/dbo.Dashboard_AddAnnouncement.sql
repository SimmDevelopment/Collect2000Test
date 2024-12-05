SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Dashboard_AddAnnouncement]
	@Title varchar(50) = '', @Announcement varchar(250) = ''
AS
BEGIN
  INSERT INTO Announcements (Created, Title, Announcement)
  VALUES (getdate(), @Title, @Announcement)
  
  SELECT cast(scope_identity() as int) as AnnouncementID
END
GO
