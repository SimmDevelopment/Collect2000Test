SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description:	First remove any associations with disabled cbr_config records, then 
--	check all records and validate that no customerid has more than one enabled record.
--	If more than one enabled record found then leave the most recent one and disable remaining.
--	Optionally this may also check for records bound to the default, and remove/disable those...
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.cbr_config_customer_CLEAN.sql $
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
CREATE PROCEDURE [dbo].[cbr_config_customer_CLEAN] 
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Err int
	DECLARE @Rows int

	DECLARE @DupEnabled TABLE (
		[CustomerID] int NOT NULL,
		[MaxID] int NULL
	);

	-- First lets remove any associations to disabled cbr_config records...
	UPDATE c 
	SET Enabled = 0, Updated = GETDATE(), UpdatedBy = 'CLEAN'
	FROM cbr_config_customer AS c INNER JOIN cbr_config cfg
		ON c.cbr_config_id = cfg.id AND c.enabled = 1 AND cfg.enabled = 0
	
	-- collect the error and row count values...
	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT

	-- If we received an error then simply return with the error value.
	IF @Err <> 0 
		RETURN @Err
	
	-- Next we only care about customers with multiple enabled rows
	-- Get the customerid and maximum id value for the customers that meet the HAVING criteria...
	INSERT INTO @DupEnabled (CustomerId, MaxId) 
		SELECT customerid, MAX(id) AS MaxId 
		FROM cbr_config_customer 
		WHERE enabled = 1
		GROUP BY customerid 
		HAVING COUNT(customerid) > 1
	
	-- collect the error and row count values...
	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT

	-- If we received an error then simply return with the error value.
	IF @Err <> 0 
		RETURN @Err
		
	-- If there are no rows affected then we are done...
	IF @Rows = 0 
		RETURN @Err
		
	-- If we are here, then we need to update the cbr_config_customer table for the found records...
	UPDATE c 
	SET Enabled = 0, Updated = GETDATE(), UpdatedBy = 'CLEAN'
	FROM cbr_config_customer AS c INNER JOIN @DupEnabled d
		ON c.customerid = d.customerid AND c.id <> d.maxid AND c.enabled = 1

	-- collect the error and row count values...
	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT

	-- Simply return the error value (sb 0 on success)
	RETURN @Err
END

GO
