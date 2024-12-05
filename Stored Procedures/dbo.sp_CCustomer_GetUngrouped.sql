SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_GetUngrouped*/
CREATE Procedure [dbo].[sp_CCustomer_GetUngrouped]
	/* Param List */
AS

SELECT C.*
FROM Customer C
WHERE C.customer NOT IN 
	(SELECT customerid FROM fact WHERE customerid IS NOT NULL)

GO
