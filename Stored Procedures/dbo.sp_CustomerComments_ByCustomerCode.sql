SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









/*CREATE   PROCEDURE sp_CustomerComments_ByCustomerCode*/
CREATE   PROCEDURE [dbo].[sp_CustomerComments_ByCustomerCode]
@CustomerCode varchar(7)
AS 
/*
** Name:		sp_CustomerComments_ByCustomerCode
** Function:		This procedure will retrieve all customer comments from
**			CustomerComments table using input parameter @CustomerCode.
** Creation:		6/4/2002 jc
**			Used by class CCustomerCommentFactory. 
** Change History:
*/
SELECT cc.*, c.Name AS CustomerName FROM CustomerComments AS cc
	INNER JOIN Customer c ON cc.CustomerCode = c.Customer
	WHERE cc.CustomerCode = @CustomerCode
	ORDER BY cc.DateTimeCreated DESC


GO
