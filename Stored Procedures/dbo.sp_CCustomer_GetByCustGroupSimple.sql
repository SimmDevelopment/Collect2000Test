SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_GetByCustGroupSimple */
CREATE Procedure [dbo].[sp_CCustomer_GetByCustGroupSimple]
	@GroupID int
AS

--Used for best performance on NewBusiness->Select Customer
SELECT C.name, C.customer
FROM Customer C
JOIN fact F on C.customer = F.customerid
WHERE F.customgroupid = @GroupID
ORDER BY C.Name

GO
