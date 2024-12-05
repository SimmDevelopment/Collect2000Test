SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[AIM_InsertPaymentAuditRecord]
@number int,
@paymentamount money,
@receivingagencyid int,
@creditingagencyid int,
@batchfilehistoryid int,
@subbatchtype varchar(5),
@isfeeonly bit = 0,
@feeamount money = 0.0,
@error bit,
@batchtype varchar(5) = null,
@paymentidentifier varchar(30) = null

AS

BEGIN

IF(@batchtype is null)
BEGIN
SET @batchtype = @subbatchtype
END


INSERT INTO AIM_PaymentAudit
(Number,BatchFileHistoryId,PaymentAmount,FeeAmount,IsFeeOnly,ReceivingAgencyId,CreditingAgencyId,BatchType,SubBatchType,Processed,ThrewException,PaymentIdentifier,DateTimeEntered)
VALUES
(@number,@batchfilehistoryid,@paymentamount,@feeamount,@isfeeonly,@receivingagencyid,@creditingagencyid,@batchtype,@subbatchtype,
0 ,@error,@paymentidentifier,getdate())

END





GO
