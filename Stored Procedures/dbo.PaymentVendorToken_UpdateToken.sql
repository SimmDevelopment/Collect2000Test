SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2009/09/02
-- Description:	update Token information
-- $History: /GSSI/Core/Database/8.1.0/StoredProcedures/dbo.PaymentVendorToken_UpdateToken.sql $
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
CREATE PROCEDURE [dbo].[PaymentVendorToken_UpdateToken] 
	@UID int,
	@Token varchar(255), 
	@TokenOrigin varchar(255),
	@TokenUpdated datetime OUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @TokenUpdated = GETDATE()

	UPDATE [dbo].[PaymentVendorToken]
	SET [Token] = @Token, [TokenUpdated] = @TokenUpdated, [TokenOrigin] = @TokenOrigin
	WHERE [id] = @UID

	RETURN @@ERROR
END

GO
