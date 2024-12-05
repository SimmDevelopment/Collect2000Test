SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2009/09/02
-- Description:	Insert a record
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.PaymentVendorToken_Insert.sql $
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
CREATE PROCEDURE [dbo].[PaymentVendorToken_Insert] 
	@Token varchar(255), 
	@Hash varchar(255),
	@TokenOrigin varchar(255),
	@MaskedValue varchar(255),
	@PayMethodId int, 
	@PayMethodCode varchar(20),
	@PayMethodSubTypeCode varchar(50),
	@LastResult varchar(50) = 'CREATED',
	@CreatedBy varchar(255), 
	@TokenUpdated datetime OUT,
	@LastResultDate datetime OUT,
	@Created datetime OUT,
	@UID int OUT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Err int
	SET @Created = GETDATE()
	SET @TokenUpdated = @Created
	SET @LastResultDate = @Created

	INSERT INTO [dbo].[PaymentVendorToken]
           ([Token]
           ,[TokenUpdated]
           ,[Hash]
           ,[TokenOrigin]
           ,[MaskedValue]
           ,[PayMethodId]
           ,[PayMethodCode]
           ,[PayMethodSubTypeCode]
           ,[LastResult]
           ,[LastResultDate]
           ,[Created]
           ,[CreatedBy])
     VALUES
           (@Token
           ,@TokenUpdated
           ,@Hash
           ,@TokenOrigin
           ,@MaskedValue
           ,@PayMethodId
           ,@PayMethodCode
           ,@PayMethodSubTypeCode
           ,@LastResult
           ,@LastResultDate
           ,@Created
           ,@CreatedBy)

	SET @Err = @@ERROR
	IF @Err <> 0 RETURN @Err

	SET @UID = SCOPE_IDENTITY()

	RETURN @@ERROR

END

GO
