SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Custom_Target_ProcessPayment]
@number int
AS

DECLARE @currDate datetime

SET @currDate = DATEADD(day, 0, DATEDIFF(day, 0, GETDATE()))

UPDATE PaymentBatchItems
SET CheckNumber = '{' + CONVERT(varchar, IDENT_CURRENT('Custom_TargetAck')) + '}'
WHERE FileNum = @number AND DATEADD(day, 0, DATEDIFF(day, 0, Created)) = @currDate
	

GO
