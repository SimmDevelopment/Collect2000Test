SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*CREATE PROCEDURE sp_CustomerComments_Delete*/
CREATE PROCEDURE [dbo].[sp_CustomerComments_Delete]
@Id int 
AS 
/*
** Name:		sp_CustomerComments_Delete
** Function:		This procedure will delete a customer comment from the CustomerComments table
** 			using input parameter @Id.
** Creation:		6/4/2002 jc
**			Used by class CCustomerCommentFactory. 
** Change History:
*/
DELETE FROM CustomerComments
	WHERE Id = @Id


GO
