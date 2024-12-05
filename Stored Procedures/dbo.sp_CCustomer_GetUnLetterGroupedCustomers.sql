SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_GetUnLetterGroupedCustomers*/
CREATE Procedure [dbo].[sp_CCustomer_GetUnLetterGroupedCustomers]
	/* Param List */
AS

SELECT C.*
FROM Customer C
WHERE C.customer NOT IN 
	(SELECT fact.CustomerID
	 FROM fact
	 JOIN CustomCustGroups CCG ON fact.CustomGroupID = CCG.ID
	 WHERE fact.CustomerID IS NOT NULL
	 AND CCG.LetterGroup = 1)

GO
