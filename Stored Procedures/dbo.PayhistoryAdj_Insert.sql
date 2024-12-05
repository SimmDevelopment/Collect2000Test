SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*PayhistoryAdj_Insert Procedure*/
CREATE    PROCEDURE [dbo].[PayhistoryAdj_Insert]
	@AccountID int,
	@BatchType varchar (3),
	@Comment varchar (100),
	@TotalPaid money,
	@Paid1 money,
	@Paid2 money,
	@Paid3 money,
	@Paid4 money,
	@Paid5 money,
	@Paid6 money,
	@Paid7 money,
	@Paid8 money,
	@Paid9 money,
	@Paid10 money,
	@ReturnID int output
AS
 /*
**Name		:PayhistoryAdj_Insert	
**Function	:Adds an adjusting entry to the Payhistory Table, Updates the master record
**Creation	:11/19/2003 mr	
**Used by 	:Latitude.exe  Balance Adjustment	
**		:3/4/2004 mr Changed IF Batchtype = 'DAR'  to  IF Batchtype = 'DA' to fix a bug that was decreasing
**		:the current fields rather than increasing them on DARs and vice versa. In DBU4023 and
**		:also DBU4021	
**Change History:	
*/

Declare @Cust varchar(7)
Declare @Desk varchar(10)
Declare @SysMonth tinyint
Declare @SysYear smallint
Declare @TheDate DateTime
Declare @LoginName varchar(10)
Declare @Err int
DECLARE @Current1 MONEY;
DECLARE @Current2 MONEY;
DECLARE @Current3 MONEY;
DECLARE @Current4 MONEY;
DECLARE @Current5 MONEY;
DECLARE @Current6 MONEY;
DECLARE @Current7 MONEY;
DECLARE @Current8 MONEY;
DECLARE @Current9 MONEY;
DECLARE @Current10 MONEY;
DECLARE @PaidToDate MONEY;


If @BatchType not in ('DA', 'DAR')
	Return -1

Select @Cust=Customer,@Desk=Desk from Master where number = @AccountID
Select @SysMonth=CurrentMonth, @SysYear=CurrentYear from ControlFile
Set @TheDate = cast(CONVERT(varchar, GETDATE(), 107)as datetime)

SELECT @Current1 = [current1],
	@Current2 = [current2],
	@Current3 = [current3],
	@Current4 = [current4],
	@Current5 = [current5],
	@Current6 = [current6],
	@Current7 = [current7],
	@Current8 = [current8],
	@Current9 = [current9],
	@Current10 = [current10],
	@PaidToDate = [paid]
FROM [dbo].[master]
WHERE [number] = @AccountID;

Select @LoginName = LoginName
From dbo.GetCurrentLatitudeUser()


Begin Tran

INSERT INTO Payhistory (number, seq, batchtype, paytype, matched, customer, systemmonth, systemyear, entered, desk,
			Invoiced, Comment, DatePaid, totalPaid, Paid1, Paid2, Paid3, Paid4, Paid5, Paid6,
			Paid7, Paid8, Paid9, Paid10, Fee1, Fee2, Fee3, Fee4, Fee5, Fee6, Fee7, Fee8, Fee9,
			Fee10, InvoiceFlags, OverpaidAmt, ForwardeeFee, CreatedBy, BatchPmtCreatedBy,
			Balance, Balance1, Balance2, Balance3, Balance4, Balance5, Balance6, Balance7, Balance8, Balance9, Balance10,
			paymethod, checknbr, invoicesort, invoicetype, invoicepaytype, paidtodate)
		VALUES (@AccountID, 0, @Batchtype, CASE @BatchType WHEN 'DA' THEN 'Adjustment Down' ELSE 'Adjustment Up' END, 'N', @Cust, @SysMonth, @SysYear, @TheDate, @Desk,
			@TheDate, @Comment, @TheDate, @TotalPaid, @Paid1, @Paid2, @Paid3, @Paid4, @Paid5, @Paid6,
			@Paid7, @Paid8, @Paid9, @Paid10, 0,0,0,0,0,0,0,0,0,
			0, '0000000000', 0,0, @LoginName, @LoginName,
			(@Current1 + @Current2 + @Current3 + @Current4 + @Current5 + @Current6 + @Current7 + @Current8 + @Current9 + @Current10), @Current1, @Current2, @Current3, @Current4, @Current5, @Current6, @Current7, @Current8, @Current9, @Current10,
			'', '', '', '', 3.0, @PaidToDate);

	Set @Err = @@Error
	If @Err = 0 
		Select @ReturnID = SCOPE_IDENTITY()
	Else
		Goto RollbackTran

IF @BatchType = 'DA' Begin
	Set @TotalPaid = - @TotalPaid
	Set @Paid1 = - @Paid1
	Set @Paid2 = - @Paid2
	Set @Paid3 = - @Paid3
	Set @Paid4 = - @Paid4
	Set @Paid5 = - @Paid5
	Set @Paid6 = - @Paid6
	Set @Paid7 = - @Paid7
	Set @Paid8 = - @Paid8
	Set @Paid9 = - @Paid9
	Set @Paid10 = - @Paid10
END

UPDATE Master set current0 = current0 + @TotalPaid, Current1=Current1+@Paid1, Current2=Current2+@Paid2,
	Current3=Current3+@Paid3, Current4=Current4+@Paid4, Current5=Current5+ @Paid5,
	Current6=Current6+@Paid6, Current7=Current7+@Paid7, Current8=Current8+@Paid8,
	Current9=Current9+@Paid9, Current10=Current10+@Paid10, Accrued2=Accrued2 + @Paid2,
	Accrued10=Accrued10+@Paid10
Where Number = @AccountID

Set @Err = @@Error
If @Err = 0 BEGIN
	Commit Tran
	Return @Err
End

RollbackTran:
	Rollback Tran
	Return @Err




GO
