SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSelectMenusByTreePath    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionSelectMenusByTreePath]
(
	@TreePath varchar(1000)
)
AS
	SET NOCOUNT ON;
SELECT     ID, Name, TreePath, URL, ReportDefinition, Target
FROM         LionMenus
WHERE     (TreePath = @TreePath)
GO
