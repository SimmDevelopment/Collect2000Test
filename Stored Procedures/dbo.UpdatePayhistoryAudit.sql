SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*UpdatePayhistoryAudit Procedure*/
CREATE PROCEDURE [dbo].[UpdatePayhistoryAudit]
	@PaymentBatchId int,
	@PaymentBatchItemsId int,
	@PayhistoryId int
AS

 /*
**Name		:UpdatePayhistoryAudit	
**Function	:Adds a updates the payhistoryid field in the PayhistoryAudit Table
**Creation	:MDD 5/9/2006
**Used by 	:C2KPmt		
**Parameters	
 		- @PaymentBatchId
 		- @PaymentBatchItemsId
 		- @PayhistoryId

**Change History:
*/

UPDATE PayhistoryAudit SET PayhistoryId = @PayhistoryId WHERE PaymentBatchId = @PaymentBatchId AND PaymentBatchItemsId = @PaymentBatchItemsId

Return @@Error

GO
