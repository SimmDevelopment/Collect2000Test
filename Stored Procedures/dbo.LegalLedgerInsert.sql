SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*LegalLedgerInsert*/
CREATE  PROCEDURE [dbo].[LegalLedgerInsert] 
	@PayhistoryID int,
	@AccountID int,
	@Customer varchar(7),
	@EntryDate datetime,
	@DebitAmt money,
	@CreditAmt money,
	@Description varchar(50),
	@Invoiceable bit,
	@ReturnID int output
AS
 /*
** Name:		LegalLedgerInsert
** Function:		Inserts a record into Legal_Ledger table
** Creation:		6/25/2003 mr
**			Used by class GSSAccounting.LegalLedgerItems and PmtBatchLegalItem_Process
** Change History:	7/15/03  mr Added Payhistory column to table and parameter.  Payhistory only has a
**				    value if the item is created in a Payment entry. DBUpdate 4.0.15
**			10/26/04 mr Added Invoiceable DBUpdate 4.0.32 (not really needed til v5)
*/

	IF (@DebitAmt <> 0) and (@CreditAmt <> 0)
		Return -1   --one of them must be 0
	ELSE BEGIN
		INSERT INTO Legal_Ledger(PayhistoryID, AccountID, Customer, ItemDate, DebitAmt, CreditAmt, Description, Invoiceable)
		VALUES (@PayhistoryID, @AccountID, @Customer, @EntryDate, @DebitAmt, @CreditAmt, @Description, @Invoiceable)
	
		IF @@Error = 0 BEGIN
			Select @ReturnID = SCOPE_IDENTITY()
			Return 0
		END
		ELSE
			Return @@Error
	END


GO
