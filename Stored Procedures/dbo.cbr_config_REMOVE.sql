SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description:	Remove (disable) all records for the given config setup.
--		Before removing, first remove all the associations for any cbr_config_customer records...
-- History: tag removed
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2010-03-15   Time: 12:36:29-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Case 37324: multiple cbr_config records and customer associations. 
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2010-03-15   Time: 12:11:50-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Added cbr_config sprocs... 
-- =============================================
CREATE PROCEDURE [dbo].[cbr_config_REMOVE] 
	@cbr_config_Id int
	,@UpdatedBy varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Err int
	DECLARE @Rows int

	-- disable all the enabled association records for the given cbr_config_id.
	-- in the future we need to audit this action...
	UPDATE cbr_config_customer
	SET enabled = 0, Updated = GETDATE(), UpdatedBy = @UpdatedBy
	WHERE cbr_config_Id = @cbr_config_Id AND enabled = 1

	-- collect the error and row count values...
	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT

	-- if there was an error we need to exit and return the error value.
	IF @Err <> 0
		RETURN @Err
	
	-- in the future we need to audit this action...
	UPDATE cbr_config 
	SET enabled = 0
	WHERE id = @cbr_config_Id
	
	-- Simply return the error value (sb 0 on success)
	RETURN @@ERROR
END
GO
