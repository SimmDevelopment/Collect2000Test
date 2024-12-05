SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  View dbo.LionStatusView    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE VIEW [dbo].[LionStatusView]
AS
SELECT     code, Description
FROM         dbo.status

GO
