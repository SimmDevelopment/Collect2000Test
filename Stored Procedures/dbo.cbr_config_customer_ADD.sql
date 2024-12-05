SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description:	Insert a record for the given customer and the given config setup.
--		Remove any previous enabled records first.
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.cbr_config_customer_ADD.sql $
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2010-03-16   Time: 13:48:29-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Awareness and handling of default record 
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
CREATE PROCEDURE [dbo].[cbr_config_customer_ADD] 
	@CustomerCode varchar(7)
	,@cbr_config_id int = 0
	,@UpdatedBy varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Err int
	DECLARE @Rows int
	
	-- First, remove any existing associations for this customer...
	EXEC @Err = cbr_config_customer_REMOVE @CustomerCode, @UpdatedBy

	-- If we received an error then simply return with the error value.
	IF @Err <> 0 
		RETURN @Err

	IF @CustomerCode IS NULL
	BEGIN
		INSERT INTO [dbo].[cbr_config_customer]
			([CustomerId]
			,[cbr_config_id]
			,[Created]
			,[CreatedBy]
			,[Enabled]
			,[Updated]
			,[UpdatedBy])
		VALUES 
			(null
			,@cbr_config_id
			,GETDATE()
			,@UpdatedBy
			,1
			,GETDATE()
			,@UpdatedBy)
			
		-- collect the error and row count values...
		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[cbr_config_customer]
			([CustomerId]
			,[cbr_config_id]
			,[Created]
			,[CreatedBy]
			,[Enabled]
			,[Updated]
			,[UpdatedBy])
		SELECT ccustomerid
			,@cbr_config_id
			,GETDATE()
			,@UpdatedBy
			,1
			,GETDATE()
			,@UpdatedBy
		 FROM customer 
		 WHERE customer = @CustomerCode
		
		-- collect the error and row count values...
		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
	END
	
	-- Simply return the error value (sb 0 on success)
	RETURN @Err

END

GO
