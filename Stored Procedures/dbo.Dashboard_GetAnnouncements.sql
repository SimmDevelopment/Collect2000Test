SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Dashboard_GetAnnouncements]
   @UserId INT = null
AS
BEGIN
  SELECT * FROM Announcements a
  WHERE (TeamID IS NULL OR TeamID IN (SELECT t.ID FROM Teams t INNER JOIN Desk d ON t.ID=d.TeamID INNER JOIN Users u ON u.DeskCode=d.Code WHERE u.ID=@UserID))
  AND a.Created < dateadd(day, 1, convert(char(8), getdate(), 112))
  ORDER BY a.Created DESC
END

GO
