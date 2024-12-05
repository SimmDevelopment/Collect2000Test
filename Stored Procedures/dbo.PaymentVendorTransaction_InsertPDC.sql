SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2009/09/14
-- Description:	Insert a record with a reference to pdc record.
-- History: tag removed
--  
--  ****************** Version 3 ****************** 
--  User: mdevlin   Date: 2010-09-03   Time: 13:32:45-04:00 
--  Updated in: /GSSI/Core/Database/8.3.0/StoredProcedures 
--  
--  ****************** Version 4 ****************** 
--  User: mdevlin   Date: 2010-09-03   Time: 13:30:04-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  VendorReferenceNumber --> 50 chars 
--  
--  ****************** Version 3 ****************** 
--  User: mdevlin   Date: 2010-02-04   Time: 13:12:39-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Added PaymentLinkUID 
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2009-10-12   Time: 11:33:38-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  support new columns for AuthorizationCode, InstitutionReferenceNumber, and 
--  ExtraReferenceNumber. 
--  
--  ****************** Version 1 ****************** 
--  User: jbryant   Date: 2009-09-22   Time: 15:53:15-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  New Procedures added for 9.0.0 
-- =============================================
CREATE PROCEDURE [dbo].[PaymentVendorTransaction_InsertPDC] 
	@ScheduledPaymentID int, 
	@PaymentVendorSeriesPaymentId int,
	@PaymentVendorTokenId int,
	@Amount money,
	@AuthDate datetime,
	@TransactionResultCode [varchar](50),
	@TransactionResultDescription [varchar](255),
	@VendorBatchNumber [varchar](50), 
	@VendorReferenceNumber [varchar](50),
	@AuthorizationCode [varchar](50),
	@InstitutionReferenceNumber [varchar](50),
	@ExtraReferenceNumber [varchar](50),
	@IsSurcharge [varchar](50),
	@CreatedBy [varchar](255), 
	@PaymentLinkUID int,
	@Created datetime OUT,
	@Id int OUT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Err int
	SET @Created = GETDATE()

INSERT INTO [dbo].[PaymentVendorTransaction]
           ([PDCId]
           ,[DebtorCreditCardId]
           ,[PaymentVendorSeriesPaymentId]
           ,[PaymentVendorTokenId]
           ,[Amount]
           ,[AuthDate]
           ,[AuthErrCode]
           ,[AuthErrDesc]
           ,[VendorBatchNumber]
           ,[VendorReferenceNumber]
           ,[AuthorizationCode]
           ,[InstitutionReferenceNumber]
           ,[ExtraReferenceNumber]
           ,[IsSurcharge]
           ,[Created]
           ,[CreatedBy]
           ,[PaymentLinkUID])
     VALUES
           (@ScheduledPaymentID, 
           	null,
			@PaymentVendorSeriesPaymentId,
			@PaymentVendorTokenId,
			@Amount,
			@AuthDate,
			@TransactionResultCode,
			@TransactionResultDescription,
			@VendorBatchNumber, 
			@VendorReferenceNumber,
			@AuthorizationCode,
			@InstitutionReferenceNumber,
			@ExtraReferenceNumber,
			@IsSurcharge, 
			@Created,
			@CreatedBy,
			@PaymentLinkUID
			)

	SET @Err = @@ERROR
	IF @Err <> 0 RETURN @Err

	SET @Id = SCOPE_IDENTITY()

	RETURN @@ERROR

END
GO
