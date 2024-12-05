SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*CREATE  PROCEDURE sp_CustomerComments_Insert*/
CREATE  PROCEDURE [dbo].[sp_CustomerComments_Insert]
@CustomerCode varchar(7),
@Comment varchar(5000),
@CreatedBy varchar(32)
AS
/*
** Name:		sp_CustomerComments_Insert
** Function:		This procedure will insert a customer comment into CustomerComments table
** 			using input parameters @CustomerCode and @Comment.
** Creation:		6/4/2002 jc
**			Used by class CCustomerCommentFactory. 
** Change History:
*/
INSERT INTO CustomerComments (CustomerCode, Comment, CreatedBy) 
	VALUES (@CustomerCode, @Comment, @CreatedBy)


GO
