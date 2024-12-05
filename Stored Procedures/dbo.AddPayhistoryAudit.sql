SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*AddPayhistoryAudit Procedure*/
CREATE PROCEDURE [dbo].[AddPayhistoryAudit]
	@FieldName varchar(256),
	@FieldOldValue varchar(256),
	@FieldNewValue varchar(256),
	@PaymentBatchId int,
	@PaymentBatchItemsId int,
	@LatitudeUser varchar(256)
AS

 /*
**Name		:AddPayhistoryAudit	
**Function	:Adds a record in the PayhistoryAudit Table
**Creation	:MDD 5/9/2006
**Used by 	:C2KPmt		
**Parameters	
 		- @FieldName	The field that was modified
 		- @FieldOldValue	
 		- @FieldNewValue
 		- @PaymentBatchId
 		- @PaymentBatchItemsId
 		- @LatitudeUser

**Change History:
*/

IF ISNULL(@LatitudeUser, suser_sname()) = '' 
	Select @LatitudeUser = suser_sname()
ELSE
	Select @LatitudeUser = @LatitudeUser

INSERT INTO PayhistoryAudit 
(FieldName,FieldOldValue,FieldNewValue,PaymentBatchId,PaymentBatchItemsId,CreatedBy,PayhistoryId)
Values (@FieldName,@FieldOldValue,@FieldNewValue,@PaymentBatchId,@PaymentBatchItemsId,@LatitudeUser,null)

Return @@Error

GO
