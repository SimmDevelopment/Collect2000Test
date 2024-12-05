SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Description:	Insert a new record given all the applicable information.
-- History: tag removed
--  
--  ****************** Version 3 ****************** 
--  User: mdevlin   Date: 2010-10-06   Time: 09:54:07-04:00 
--  Updated in: /GSSI/Core/Database/8.3.0/StoredProcedures 
--  Charge-off 
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2010-09-30   Time: 11:09:28-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  IndustryCode for Charge-off 
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2010-03-15   Time: 12:11:50-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Added cbr_config sprocs... 
-- =============================================
CREATE PROCEDURE [dbo].[cbr_config_ADD] 
	@InnovisID varchar(10)
	,@EquifaxID varchar(10)
	,@ExperianID varchar(10)
	,@TransUnionID varchar(10)
	,@ReporterName  varchar(40) 
	,@ReporterAddress varchar(96)
	,@ReporterPhone varchar(10)
	,@BaseIdNumber varchar(20) 
	,@UpdatedBy varchar(255)
	,@IndustryCode varchar(10)
	,@Id int OUT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Err int
	DECLARE @Rows int
	
	-- For now we are ignoring the UpdatedBy parm, it is for future use in auditing...
	
	-- just insert the record with the given values...
	INSERT INTO [dbo].[cbr_config]
		([enabled]
		,[InnovisID]
		,[EquifaxID]
		,[ExperianID]
		,[TransUnionID]
		,[ReporterName]
		,[ReporterAddress]
		,[ReporterPhone]
		,[BaseIdNumber]
		,[lastEvaluated]
		,[IndustryCode])
     VALUES
     	(1
     	,@InnovisID
     	,@EquifaxID
     	,@ExperianID
     	,@TransUnionID
     	,@ReporterName
     	,@ReporterAddress
     	,@ReporterPhone
     	,@BaseIdNumber
     	,null
     	,@IndustryCode)

	-- collect the error and row count values...
	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT

	-- if there was an error we need to exit and return the error value.
	IF @Err <> 0
		RETURN @Err
		
	-- Grab the identity value for this record and place in out variable.
	SET @Id = SCOPE_IDENTITY()
	
	-- Simply return the error value (sb 0 on success)
	RETURN @@ERROR

END
GO
