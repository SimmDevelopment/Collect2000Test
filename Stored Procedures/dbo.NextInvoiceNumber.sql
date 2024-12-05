SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[NextInvoiceNumber] 
	@NextInvoiceNumber int  OUTPUT
AS
	DECLARE @RowCount int
	DECLARE @Err int
	DECLARE @MaxInvoiceNumber int

	BEGIN TRANSACTION
	SAVE TRANSACTION GetNextInvoiceNumber

	UPDATE NextInvoice SET Invoice = Invoice + 1, TDate = GETDATE()
	SELECT @Err = @@ERROR, @RowCount = @@ROWCOUNT

	IF @Err = 0 AND @RowCount = 0
	BEGIN
		-- No error, but no rows changed (must not be a row).
		-- So lets insert one now.
		SELECT @MaxInvoiceNumber = ISNULL(MAX(Invoice), 0) FROM invoicesummary
		SELECT @Err = @@ERROR, @RowCount = @@ROWCOUNT
		IF @Err = 0
		BEGIN
			INSERT INTO NextInvoice (Invoice, TDate) VALUES (@MaxInvoiceNumber + 1, GETDATE())
			SELECT @Err = @@ERROR, @RowCount = @@ROWCOUNT
		END
	END

	IF @Err = 0
	BEGIN
		-- We should have exactly one row to query now...
		SELECT TOP 1 @NextInvoiceNumber = Invoice from NextInvoice
		SELECT @Err = @@ERROR, @RowCount = @@ROWCOUNT
	END

	IF @Err <> 0 
	BEGIN
		ROLLBACK TRANSACTION GetNextInvoiceNumber
	END
	ELSE
	BEGIN
		COMMIT TRANSACTION
	END

	RETURN @Err


GO
