SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*spCalculateTax*/
CREATE PROCEDURE [dbo].[spCalculateTax]
	@AccountID int,
	@FeeAmount money,
	@TaxAmount money Output
AS

Declare @Customer varchar (7)
Declare @OurState varchar (3)
Declare @DebtorState varchar (3)
Declare @CustomerState varchar (3)

Set @TaxAmount = 0
Select @OurState = State from ControlFile
Select @DebtorState = rtrim(State), @Customer = Customer from master where number = @AccountID
Select @CustomerState = State from Customer where Customer = @Customer

IF (@OurState = 'PA') and (@CustomerState = 'PA') and (@DebtorState = 'PA') BEGIN
	SET @TaxAmount = @FeeAmount * .06
	print 'Its Equal'
end
--print cast(@TaxAmount as varchar)

RETURN @@Error
GO
