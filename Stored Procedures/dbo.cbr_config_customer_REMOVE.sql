SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description:	Remove (enabled = 0) all records for the given customer.
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.cbr_config_customer_REMOVE.sql $
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
CREATE PROCEDURE [dbo].[cbr_config_customer_REMOVE] 
	@CustomerCode varchar(7)
	,@UpdatedBy varchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	
	-- ideally there will never be more than one row affected here, but 
	-- we are just gonna go ahead and update any that are enabled for the customer...
	IF @CustomerCode IS NULL
	BEGIN
		UPDATE cbr_config_customer
		SET enabled = 0, Updated = GETDATE(), UpdatedBy = @UpdatedBy
		WHERE enabled = 1 AND customerid IS NULL 
	END
	ELSE
	BEGIN
		UPDATE cbr_config_customer
		SET enabled = 0, Updated = GETDATE(), UpdatedBy = @UpdatedBy
		WHERE enabled = 1 AND customerid = (SELECT ccustomerid FROM customer WHERE customer = @customerCode) 
	END

	-- Simply return the error value (sb 0 on success)
	RETURN @@ERROR
END

GO
