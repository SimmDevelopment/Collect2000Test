SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustomCustGroup_RemoveCustomer*/
CREATE Procedure [dbo].[sp_CustomCustGroup_RemoveCustomer]
	@CustomCustGroupID int,
	@Customer varchar(7)
AS

DELETE FROM FACT
WHERE CustomerID = @Customer AND CustomGroupID = @CustomCustGroupID

GO
