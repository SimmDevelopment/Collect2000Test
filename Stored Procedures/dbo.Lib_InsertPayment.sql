SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*[Lib_InsertPayment]*/
CREATE  PROCEDURE [dbo].[Lib_InsertPayment] 
@BatchNumber int,
@FileNumber int,
@Entered datetime, 
@Datepaid datetime,
@BatchType tinyint,
@Paid0 money,
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
@Fee0 money,
@Fee1 money,
@Fee2 money,
@Fee3 money, 
@Fee4 money,
@Fee5 money,
@Fee6 money,
@Fee7 money,
@Fee8 money,
@Fee9 money, 
@Fee10 money,
@InvoiceFlags varchar (10),
@OverPaidAmt money,
@ForwardeeFee money, 
@IsPIF bit,
@IsSettlement bit,
@Comment varchar (30),
@InvKeyCode tinyint, 
@PayMethod varchar (30), 
@ReverseOfUID int, 
@Surcharge money,
@CollectorFee money,
@FeeSched char(5),
@CollectorFeeSched char(5),
@Desk varchar(10),
@IsFreeDemand bit, 
@IsCorrection bit,
@LatitudeUser varchar(256),
@CheckNumber varchar(30),
@CurrencyISO3 char(3),
@AimBatchId int,
@AimSendingID int,
@SubBatchType char(3),
@DebtorID int,
@PaymentLinkUID int,
@Tax money,
@PAIdentifier int,
@AIMAgencyId int,
@AIMDueAgency money,
@AIMAgencyFee money,
@PostDateUID int,
@UID int output
AS 

DECLARE @RC int;
DECLARE @CalculatedTax money;

SET @LatitudeUser = ISNULL(@LatitudeUser, suser_sname())

EXECUTE @RC = spCalculateTax @FileNumber, @Fee0, @TaxAmount = @CalculatedTax OUTPUT

IF @RC = 0
BEGIN
	-- set the tax amount to the calcutated amount if @Tax parm value is null, and spCalculateTax succeeded.
	SET @Tax = ISNULL(@Tax, @CalculatedTax)
END

INSERT INTO [PaymentBatchItems]
           ([BatchNumber]
           ,[FileNum]
           ,[DatePaid]
           ,[Entered]
           ,[PmtType]
           ,[Paid0]
           ,[Paid1]
           ,[Paid2]
           ,[Paid3]
           ,[Paid4]
           ,[Paid5]
           ,[Paid6]
           ,[Paid7]
           ,[Paid8]
           ,[Paid9]
           ,[Paid10]
           ,[Fee0]
           ,[Fee1]
           ,[Fee2]
           ,[Fee3]
           ,[Fee4]
           ,[Fee5]
           ,[Fee6]
           ,[Fee7]
           ,[Fee8]
           ,[Fee9]
           ,[Fee10]
           ,[InvoiceFlags]
           ,[InvKeyCode]
           ,[OverPaidAmt]
           ,[ForwardeeFee]
           ,[IsPIF]
           ,[IsSettlement]
           ,[Comment]
           ,[PayMethod]
           ,[ReverseOfUID]
           ,[Surcharge]
           ,[Tax]
           ,[CollectorFee]
           ,[PAIdentifier]
           ,[AIMAgencyId]
           ,[AIMDueAgency]
           ,[AIMAgencyFee]
           ,[CheckNUmber]
           ,[FeeSched]
           ,[CollectorFeeSched]
           ,[IsCorrection]
           ,[Desk]
           ,[IsFreeDemand]
           ,[CreatedBy]
           ,[CurrencyISO3]
           ,[AIMBatchId]
           ,[AIMSendingID]
           ,[SubBatchType]
           ,[PostDateUID])
     VALUES
           (@BatchNumber
           ,@FileNumber
           ,@Datepaid
           ,@Entered
           ,@BatchType
           ,@Paid0
           ,@Paid1
           ,@Paid2
           ,@Paid3
           ,@Paid4
           ,@Paid5
           ,@Paid6
           ,@Paid7
           ,@Paid8
           ,@Paid9
           ,@Paid10
           ,@Fee0
           ,@Fee1
           ,@Fee2
           ,@Fee3
           ,@Fee4
           ,@Fee5
           ,@Fee6
           ,@Fee7
           ,@Fee8
           ,@Fee9
           ,@Fee10
           ,@InvoiceFlags
           ,@InvKeyCode
           ,@OverPaidAmt
           ,@ForwardeeFee
           ,@IsPIF
           ,@IsSettlement
           ,@Comment
           ,@PayMethod
           ,@ReverseOfUID
           ,@Surcharge
           ,@Tax
           ,@CollectorFee
           ,@PAIdentifier
           ,@AIMAgencyId
           ,@AIMDueAgency
           ,@AIMAgencyFee
           ,@CheckNumber
           ,@FeeSched
           ,@CollectorFeeSched
           ,@IsCorrection
           ,@Desk
           ,@IsFreeDemand
           ,@LatitudeUser
           ,@CurrencyISO3
           ,@AimBatchId
           ,@AimSendingID
           ,@SubBatchType
           ,@PostDateUID)

-- capture the error code...
SET @RC = @@ERROR

IF (@RC = 0) 
	Select @UID = SCOPE_IDENTITY()
ELSE 
	Set @UID = 0

RETURN @RC


GO
