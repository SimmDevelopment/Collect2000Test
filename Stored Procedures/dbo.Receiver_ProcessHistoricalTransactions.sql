SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessHistoricalTransactions]
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
where sendernumber= @file_number and clientid = @clientid;

IF(@number is null)
BEGIN
	RAISERROR ('15001', 16, 1)
	RETURN
END

	INSERT INTO [dbo].[HistoricalTransactions]
           ([FileNumber]
           ,[TransactionDate]
           ,[AmountOfTransaction]
           ,[TransactionType]
           ,[TransactionReference]
           ,[TransactionComment]
           ,[DateCreated])
     VALUES
           (@number
           ,@Date
           ,@Amount
           ,@Type
           ,@Reference
           ,@Comment
           ,GETUTCDATE())
	
END
GO
