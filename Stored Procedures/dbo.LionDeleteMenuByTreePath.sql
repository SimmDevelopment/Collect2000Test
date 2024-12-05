SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionDeleteMenuByTreePath    Script Date: 3/26/2007 9:52:00 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 10/24/2006
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[LionDeleteMenuByTreePath]
	@treePath varchar(1000)
AS
BEGIN
	SET NOCOUNT ON;

	Declare @menuId int

	Select top 1 @menuId=id from LionMenus where treepath=@treePath

	if( @menuId is null )
	BEGIN
		RAISERROR (N'Cannot find menu with treepath %s',15,1,@treePath);
	END

	EXEC LionDeleteMenuById @menuId=@menuId


END

GO
