SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_AddImportPOD]
	@ImportAcctID int,
	@InvoiceNumber varchar (25),
	@InvoiceDate datetime,
	@InvoiceDetail varchar (100),
	@InvoiceAmount money,
	@CustBranch varchar(10), 
	@ReturnStatus int Output,
	@ReturnUID int Output
 AS

	INSERT INTO ImportPODs (ImportAcctID, InvoiceNumber, InvoiceDate, InvoiceDetail, InvoiceAmount, CustBranch)
	VALUES (@ImportAcctID, @InvoiceNumber, @InvoiceDate, @InvoiceDetail, @InvoiceAmount, @CustBranch)

	IF (@@Error =  0) BEGIN
		Select @ReturnUID = SCOPE_IDENTITY()
		SET @ReturnStatus = 0
	END
	ELSE
		SET @ReturnStatus = @@Error

GO
