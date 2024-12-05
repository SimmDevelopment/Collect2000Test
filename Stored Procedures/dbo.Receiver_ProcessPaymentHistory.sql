SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessPaymentHistory]
@file_number INT,
@Type VARCHAR(1),
@Date DATETIME,
@Amount MONEY,
@Comment VARCHAR(40),
@Reference VARCHAR(20),
@clientid int
AS
BEGIN

DECLARE @number int
select @number = max(receivernumber)
from receiver_reference rr with (nolock) 
join master m with (nolock) on rr.receivernumber = m.number
where sendernumber= @file_number and clientid = @clientid

DECLARE @Customer VARCHAR(10);
SELECT TOP 1 @Customer = Customer FROM master WHERE number = @number;

IF(@number is null)
BEGIN
	RAISERROR ('15001', 16, 1)
	RETURN
END
	
	INSERT INTO [dbo].[payhistory]
			   ([datetimeentered]
			   ,[number]
			   ,[Seq]
			   ,[batchtype]
			   ,[customer]
			   ,[entered]
			   ,[desk]
			   ,[datepaid]
			   ,[totalpaid]
			   ,[comment]
			   ,[Reference]
			   ,[OverPaidAmt]
			   ,[systemmonth]
			   ,[systemyear])
		 VALUES
			   (GETUTCDATE()
			   ,@number
			   ,0
			   ,CASE @Type WHEN 'D' THEN 'PU'
								  WHEN 'C' THEN 'PUR'
								  ELSE '' END
			   ,@Customer
			   ,GETUTCDATE()
			   ,'POOL'
			   ,@Date
			   ,@Amount
			   ,@Comment
			   ,@Reference
			   ,0
			   ,DATEPART(MONTH, @Date)
			   ,DATEPART(YEAR, @Date))
END
GO
