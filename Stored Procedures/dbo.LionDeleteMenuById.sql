SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionDeleteMenuById    Script Date: 3/26/2007 9:52:00 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 10/24/2006
-- Description:	Deletes a LionMenu item and all related entries
-- =============================================
CREATE PROCEDURE [dbo].[LionDeleteMenuById]
	@menuId int
AS
BEGIN
	SET NOCOUNT ON;

	Declare @errorId int
	Declare @tranzName varchar(32)
	
	set @errorId = 0
	set @tranzName = 'DeleteLionMenu'

	if not exists(select * from LionMenus where id=@menuId)
	BEGIN
		RAISERROR (N'Menu item with id %d doesn''t exist',15,1, @menuId);
	END


	BEGIN TRANSACTION @tranzName
		
		--delete the menu item
		Delete from LionMenus where id=@menuId
		
		SELECT @errorId = @@ERROR
	    IF (@errorId <> 0) GOTO ERRORHANDLER

		--delete the LionReportRolesMenus items
		Delete from LionReportRolesMenus where MenuId=@menuId
		SELECT @errorId = @@ERROR
	    IF (@errorId <> 0) GOTO ERRORHANDLER

	COMMIT TRANSACTION @tranzName

	return

	ERRORHANDLER:
	if( @errorId != 0 )
	BEGIN
		--rollback the transaction
		ROLLBACK TRANSACTION @tranzName
		
		RAISERROR (N'Unable to delete menu item with id %d. Error id %d',15,1, @menuId,@errorId);
	END
END


GO
