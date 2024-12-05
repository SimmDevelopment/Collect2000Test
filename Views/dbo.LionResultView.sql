SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  View dbo.LionResultView    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE VIEW [dbo].[LionResultView]
AS
SELECT     code, ctl, Description, worked, contacted, note
FROM         dbo.result

GO
