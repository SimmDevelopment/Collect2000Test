SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_GetByCustGroup */
CREATE Procedure [dbo].[sp_CCustomer_GetByCustGroup]
	@GroupID int
AS

SELECT C.*
FROM Customer C
JOIN fact F on C.customer = F.customerid
WHERE F.customgroupid = @GroupID
ORDER BY C.Name

GO
