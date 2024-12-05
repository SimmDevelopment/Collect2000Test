SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Jeff Mixon
-- Create date: 04/02/2007
-- Description:	Will modify a folder in a set of TreePaths
-- =============================================
CREATE PROCEDURE [dbo].[LionUpdateMenuFolder]
	@oldFolderName	varchar(100),
	@newFolderName	varchar(100)
AS
BEGIN

	declare @transId varchar(50)
	set @transId = 'LUMF1001'

	BEGIN TRANSACTION @transId

		UPDATE LionMenus
		SET TreePath = REPLACE(TreePath, @oldFolderName, @newFolderName)
		WHERE TreePath LIKE '%' + @oldFolderName + '%'

		IF (@@ERROR <> 0)
		GOTO ERRORHANDLER

	COMMIT TRANSACTION @transId
	RETURN

	ERRORHANDLER:
	BEGIN
		ROLLBACK TRANSACTION @transid
		RAISERROR (N'Unable to set value. Error id %d',15,1, @@ERROR);
	END

END
GO
