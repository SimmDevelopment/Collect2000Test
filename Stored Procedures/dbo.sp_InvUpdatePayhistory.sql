SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[sp_InvUpdatePayhistory] 
	@UID int,
	@InvoiceNumber int,
	@InvoiceDate datetime,
	@ReturnStatus int Output
 AS


	UPDATE Payhistory set Invoice = @InvoiceNumber, Invoiced = @InvoiceDate 
	WHERE UID = @UID

	Select @ReturnStatus=@@Error
GO
