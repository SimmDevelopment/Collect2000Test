SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*CREATE  PROCEDURE sp_CustomerComments_ById*/
CREATE  PROCEDURE [dbo].[sp_CustomerComments_ById]
@Id int
AS 
/*
** Name:		sp_CustomerComments_ById
** Function:		This procedure will retrieve a single customer comments 
**			from CustomerComments table using input parameter @Id.
** Creation:		6/4/2002 jc
**			Used by class CCustomerCommentFactory. 
** Change History:
*/
SELECT cc.*, c.Name AS CustomerName FROM CustomerComments AS cc
	INNER JOIN Customer c ON cc.CustomerCode = c.Customer
	WHERE cc.Id = @Id
GO
