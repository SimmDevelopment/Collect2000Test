SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  View dbo.LionNotesView    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE VIEW [dbo].[LionNotesView]
AS
SELECT     UID, number, ctl, created, user0, action, result, comment, IsPrivate
FROM         dbo.notes

GO
