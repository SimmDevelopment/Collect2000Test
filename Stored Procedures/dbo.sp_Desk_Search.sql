SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/*CREATE        PROCEDURE sp_Desk_Search*/
CREATE        PROCEDURE [dbo].[sp_Desk_Search]
@Code varchar (10),
@Name varchar (30),
@DeskType varchar (15),
@Branch varchar (5)

AS 
/*
** Name:		sp_Desk_Search
** Function:		This procedure will search desks 
** 			using input parameters.
** Creation:		6/24/2002 jc
**			Used by class CDeskFactory. 
** Change History:
*/
	SELECT d.*, bc.Code AS BranchCode, bc.Name AS BranchName FROM Desk d
		LEFT OUTER JOIN BranchCodes bc ON bc.Code = d.Branch
		WHERE (d.code Like @Code + '%') 
			And (LTRIM(d.Name) Like @Name + '%')  
			And (isnull(d.DeskType,'') Like @DeskType + '%')  
			And (isnull(d.Branch,'') Like @Branch + '%')  
		ORDER BY d.Name

GO
