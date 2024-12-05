SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Description:	Provide a simple method of matching a promise record to a payment.
--				This sproc is meant to be called immediately after adding a batchitem.
-- $History: /GSSI/Core/Database/Dev/StoredProcedures/dbo.Promise_SimpleLinking.sql $
--  
--  ****************** Version 4 ****************** 
--  User: mdevlin   Date: 2010-02-19   Time: 08:45:35-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Only for PU type payments. 
--  
--  ****************** Version 3 ****************** 
--  User: jbryant   Date: 2010-02-17   Time: 07:06:39-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  Syntax Error 
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2010-02-15   Time: 16:25:34-05:00 
--  Updated in: /GSSI/Core/Database/Dev/StoredProcedures 
--  copied from 8.2.2 
--  
--  ****************** Version 2 ****************** 
--  User: mdevlin   Date: 2010-02-15   Time: 16:24:08-05:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  added  AND ISNULL(suspended, 0) = 0 AND ISNULL(kept, 0) = 0 
--  
--  ****************** Version 1 ****************** 
--  User: mdevlin   Date: 2010-02-15   Time: 15:10:43-05:00 
--  Updated in: /GSSI/Core/Database/8.1.0/StoredProcedures 
--  added Promise_SimpleLinking 
-- =============================================
CREATE PROCEDURE [dbo].[Promise_SimpleLinking]
    @FileNumber int,
    @Amount money,
    @PaymentLinkUID int
AS
BEGIN
	SET NOCOUNT ON;
	-- Only for PU payments...
	-- select the next promise for the account
	-- is the promise amount less than or equal to amount parm?
	-- is it active? 
	-- is the paymentlinkuid null?
	-- if so then update the promise.paymentlinkuid value with parm value.
	DECLARE @TypePU tinyint
	DECLARE @Err int
	DECLARE @Rows int
	
	SET @TypePU = 1
	
	SELECT i.UID FROM PaymentBatchItems i WHERE i.PaymentLinkUID = @PaymentLinkUID AND i.PmtType = @TypePU
	SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
	
	IF @Err <> 0 
		RETURN @Err
	
	IF @Rows > 0 
	BEGIN
		UPDATE Promises SET PaymentLinkUID = @PaymentLinkUID WHERE id in 
		(SELECT TOP 1 p.ID FROM Promises p WHERE p.AcctID = @FileNumber AND p.DueDate >= CONVERT (varchar(8), GETDATE(),112) ORDER BY p.DueDate asc)
		AND Active = 1 AND PaymentLinkUID IS null AND Amount <= @Amount AND ISNULL(suspended, 0) = 0 AND ISNULL(kept, 0) = 0

		SELECT @Err = @@ERROR, @Rows = @@ROWCOUNT
	END
	
	RETURN @Err
END

GO
