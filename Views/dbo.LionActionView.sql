SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  View dbo.LionActionView    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE VIEW [dbo].[LionActionView]
AS
SELECT     code, Description, ctl, WasAttempt, WasWorked
FROM         dbo.action

GO
