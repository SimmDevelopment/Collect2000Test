SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*CREATE      PROCEDURE sp_Salesman_Search*/
CREATE      PROCEDURE [dbo].[sp_Salesman_Search]
@Code varchar (5),
@Name varchar (30)
AS 
/*
** Name:		sp_Salesman_Search
** Function:		This procedure will search salesman
** 			using input parameters.
** Creation:		6/24/2002 jc
**			Used by class CSalesmanFactory. 
** Change History:
*/
	SELECT *
		FROM Salesman
		WHERE (code Like @Code + '%') 
			And (LTRIM(Name) Like @Name + '%')  
		ORDER BY Name

GO
