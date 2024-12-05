SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_GetUngroupedSimple*/
CREATE Procedure [dbo].[sp_CCustomer_GetUngroupedSimple]
	/* Param List */
AS

--Used for fast display of just customer names
SELECT c.[name], c.customer FROM Customer c

WHERE c.customer NOT IN 
	(SELECT customerid FROM fact WHERE customerid IS NOT NULL)

ORDER BY [name]

GO
