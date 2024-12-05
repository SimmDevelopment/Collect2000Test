SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/*CREATE    PROCEDURE sp_Attorney_Search*/
CREATE    PROCEDURE [dbo].[sp_Attorney_Search]
@Code varchar (5),
@Name varchar (30)
AS 
/*
** Name:		sp_Attorney_Search
** Function:		This procedure will search Attorney
** 			using input parameters.
** Creation:		6/25/2002 jc
**			Used by class CAttorneyFactory. 
** Change History:
*/
	SELECT *
		FROM Attorney
		WHERE (code Like @Code + '%') 
			And (Name Like @Name + '%')  
		ORDER BY Name
GO
