SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description:	Query for an association for the given customer, and return the appropriate setup id.
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.cbr_config_customer_GETASSOC.sql $
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2010-03-18   Time: 15:04:10-04:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  corrected error where returned wrong id value. 
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
CREATE PROCEDURE [dbo].[cbr_config_customer_GETASSOC]
	@CustomerCode varchar(7)
	,@cbr_config_Id int OUT
AS
BEGIN
	SET NOCOUNT ON;
	-- just get the cbr_config id value for the most recent enabled record for the customer association...
	SELECT @cbr_config_Id = cbr_config_Id 
	FROM cbr_config_customer
	WHERE id = 
		(SELECT MAX(cfg.id) 
			FROM cbr_config_customer cfg INNER JOIN customer c
				ON cfg.customerid = c.ccustomerid 
				AND cfg.enabled = 1 
				AND c.customer = @CustomerCode)
			
	-- Simply return the error value (sb 0 on success)
	RETURN @@ERROR
END

GO
