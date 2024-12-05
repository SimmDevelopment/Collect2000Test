SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2009/09/14
-- Description:	Search for a match, insert one if not found.
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.PaymentVendorBatch_GenerateId.sql $
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2010-02-09   Time: 16:53:31-05:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Added procedures from 9 
--  
--  ****************** Version 1 ****************** 
--  User: jbryant   Date: 2009-09-22   Time: 15:53:15-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  New Procedures added for 9.0.0 
-- =============================================
CREATE PROCEDURE [dbo].[PaymentVendorBatch_GenerateId] 
	@VendorCode varchar(50),
	@PayMethodCode varchar(30),
	@VendorBatchNumber varchar(50), 
	@CreatedBy varchar(255), 
	@HoldTillDate datetime OUT,
	@Created datetime OUT,
	@Id int OUT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Err int
	DECLARE @Rows int

	SELECT TOP 1 @Id = Id, @HoldTillDate = [HoldProcessingUntil], @Created = [Created]
	FROM [dbo].[PaymentVendorBatch]
	WHERE [VendorCode] = @VendorCode
		AND [PayMethodCode] = @PayMethodCode
		AND [VendorBatchNumber] = @VendorBatchNumber
		AND [Closed] IS NULL
		-- AND DATEDIFF(d,[Created], GETDATE()) < 7 -- Gets only matching records for last week
	ORDER BY [Created] DESC
	
	SELECT @Rows = @@ROWCOUNT, @Err = @@ERROR
	
	IF @Err <> 0 RETURN @Err
	
	IF @Rows = 0
	BEGIN
		SET @Created = GETDATE()
		SET @HoldTillDate = GETDATE()

		INSERT INTO [dbo].[PaymentVendorBatch]
			   ([VendorCode]
			   ,[PayMethodCode]
			   ,[HoldProcessingUntil]
			   ,[VendorBatchNumber]
			   ,[Closed]
			   ,[Created]
			   ,[CreatedBy])
		 VALUES
			   (@VendorCode
			   ,@PayMethodCode
			   ,@HoldTillDate
			   ,@VendorBatchNumber
			   ,null
			   ,@Created
			   ,@CreatedBy)

		SET @Err = @@ERROR

		IF @Err <> 0 RETURN @Err

		SET @Id = SCOPE_IDENTITY()
	END

	RETURN @Err

END

GO
