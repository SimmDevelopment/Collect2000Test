SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Placement_InsertReplacementTransaction]

@accounttransactionId int

AS

BEGIN

UPDATE AIM_AccountTransaction SET TransactionStatusTypeId = 1 WHERE AccountTransactionID = @accountTransactionId

END


GO
