SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_GetByID*/
CREATE Procedure [dbo].[sp_CCustomer_GetByID]
@CCustomerID int
AS

SELECT *
FROM Customer
WHERE CCustomerID = @CCustomerID

GO
