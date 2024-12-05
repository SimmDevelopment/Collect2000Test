SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*SP_AddOpenItemTrans **/
CREATE  PROCEDURE [dbo].[SP_AddOpenItemTrans]
	@Invoice int,
	@TransDate DateTime,
	@TransType int,
	@Amount money,
	@Comment varchar (50),
	@ReturnUID int output

 /*
**Name		:SP_AddOpenItemTrans
**Function	:Adds a transaction to an OpenItem
**Creation	:
**Used by 	:C2KFin, GSSNet Invoices
**Change History:2/17/2004 mr added a TransDate parameter instead of using GetDate()
*/

 AS

	INSERT INTO OpenItemTransactions (Invoice, TransDate, TransType, Comment, Amount)
	VALUES (@Invoice, @TransDate, @TransType, @Comment, @Amount)

	IF (@@error = 0) BEGIN
		SELECT @ReturnUID = SCOPE_IDENTITY()
	END
	ELSE BEGIN
		set @ReturnUID = -1
	END


GO
