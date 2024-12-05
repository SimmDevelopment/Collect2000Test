SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_GetByAccountID */
CREATE Procedure [dbo].[sp_CCustomer_GetByAccountID]
	@AccountID int
AS

SELECT C.*
FROM Master M
JOIN Customer C ON M.Customer = C.Customer
WHERE M.Number = @AccountID

GO
