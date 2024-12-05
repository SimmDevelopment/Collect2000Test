SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSelectLionMenuByID    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionSelectLionMenuByID]
(
	@ID int
)
AS
	SET NOCOUNT ON;
SELECT ID, Name, TreePath, URL, ReportDefinition, Target FROM dbo.LionMenus
Where ID=@ID
GO
