SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2009/09/03
-- Description:	Set the PaymentVendorTokenId for all scheduled pdc payments in an arrangement
-- History: tag removed
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2010-02-09   Time: 16:53:31-05:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  Added procedures from 9 
--  
--  ****************** Version 4 ****************** 
--  User: mdevlin   Date: 2009-11-12   Time: 15:03:14-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  exec correct sproc 
--  
--  ****************** Version 3 ****************** 
--  User: mdevlin   Date: 2009-11-09   Time: 16:51:46-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  exec paymentvendortoken_updatedebtorbankinfo 
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2009-10-14   Time: 09:47:34-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  obfuscate the debtorbankinfo data 
--  
--  ****************** Version 1 ****************** 
--  User: jbryant   Date: 2009-09-22   Time: 15:53:15-04:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  New Procedures added for 9.0.0 
-- =============================================
CREATE PROCEDURE [dbo].[PaymentVendorToken_UpdatePDCArrangement] 
	-- Add the parameters for the stored procedure here
	@PDCId int,
	@PaymentVendorTokenId int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Err INT
	DECLARE @BankId INT
    DECLARE @number INT

	SELECT @BankId = DebtorBankId, @number = number FROM pdc WHERE uid = @PDCId;

	-- Update all the pdc records for the same account and bankid.
	UPDATE PDC
	SET	[PaymentVendorTokenId] = @PaymentVendorTokenId
	WHERE number = @number AND DebtorBankID = @BankId

	EXEC @Err = PaymentVendorToken_UpdateDebtorBankInfo @BankId, @PaymentVendorTokenId 

	RETURN @Err
END
GO
