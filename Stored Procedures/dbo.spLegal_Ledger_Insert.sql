SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[spLegal_Ledger_Insert]
	@AccountID int,
	@Customer varchar (7),
	@ItemDate datetime,
	@Description varchar(50),
	@DebitAmt money,
	@CreditAmt money,
	@ReturnID int output
AS
	INSERT INTO Legal_Ledger(AccountID, Customer, ItemDate, Description, DebitAmt, CreditAmt)
	VALUES (@AccountID, @Customer, @ItemDate, @Description, @DebitAmt, @CreditAmt)

	IF @@Error = 0 BEGIN
		Select @ReturnID = SCOPE_IDENTITY()
		Return 0
	END
	Else
		Return @@Error

GO
