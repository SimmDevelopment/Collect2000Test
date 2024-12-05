SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[sp_ProcessImportPOD]
	@UID int,
	@AcctID int,
	@ReturnStatus int Output

AS


INSERT INTO PODDetail(Number, InvoiceNumber, InvoiceDate, InvoiceDetail, InvoiceAmount, PaidAmt, CurrentAmt, CustBranch)
SELECT @AcctID, InvoiceNumber, InvoiceDate, InvoiceDetail, InvoiceAmount, 0, InvoiceAmount, CustBranch From ImportPODs Where UID = @UID

IF (@@Error=0) BEGIN
	Set @ReturnStatus = 0
	Return 0
END
ELSE BEGIN
	Set @ReturnStatus = @@Error
	Return @@Error
END
GO
