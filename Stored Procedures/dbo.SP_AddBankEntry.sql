SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.SP_AddBankEntry    Script Date: 10/3/2006 9:59:33 AM ******/
CREATE PROCEDURE [dbo].[SP_AddBankEntry]
	@BankCode varchar(5),
	@EnteredDate datetime,
	@Description varchar(50),
	@Amount money,
	@Memo varchar (50),
	@PrivateMemo varchar(50),
	@CheckNumber varchar (15),
	@SubType int,
	@UserID varchar(10),
	@Invoice int,
	@CurrencyISO3 char(3),
	@UID int Output,
	@ReturnSts int Output
 AS
	DECLARE @GLType int

	/*Validate BankCode*/
	SELECT Code from Bank where Code = @BankCode

	IF (@@Rowcount = 0) BEGIN
		SET @ReturnSts = -1
	END	
	ELSE BEGIN
		/*Determine if a Debit or Credit 
			SubType 1 = Check
				  2 = Deposit
				  3 = Service Charge
				  4 = ACH In
				  5 = ACH Out
				  6 = Returned Item
				  7 = Increasing Adjustment
				  8 = Decreasing Adjustment
		
			GLType   0 = Debit
				  1 = Credit
		*/

		IF (@SubType = 2) OR (@SubType = 4) OR (@SubType = 7) BEGIN    
			SET @GLType = 0
		END
		ELSE BEGIN
			SET @GLType = 1
		END

		/*Add Entry */

		INSERT INTO BankEntries (BankCode, EnteredDate, Description, Amount, Memo, PrivateMemo, CheckNumber, GLEntryType, BankEntrySubType, UserID, Invoice, Reconciled, CurrencyISO3) 
		VALUES(@BankCode, @EnteredDate, @Description, @Amount, @Memo, @PrivateMemo, @CheckNumber, @GLType, @SubType, @UserID, @Invoice, 0, @CurrencyISO3)
		
		SELECT @UID = SCOPE_IDENTITY()
		
		IF (@@error <> 0) BEGIN
			SET @ReturnSts = -1
		END
		ELSE BEGIN
			SET @ReturnSts = 1
		END
	END


GO
