SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Dashboard_DeleteAnnouncement]
	@AnnouncementID int
AS
BEGIN
  DELETE FROM Announcements WHERE AnnouncementID=@AnnouncementID
END
GO
