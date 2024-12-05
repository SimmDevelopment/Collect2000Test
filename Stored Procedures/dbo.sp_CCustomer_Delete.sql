SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_Delete */
CREATE Procedure [dbo].[sp_CCustomer_Delete]
@CCustomerID int
AS

DELETE FROM Customer
WHERE CCustomerID = @CCustomerID

GO
