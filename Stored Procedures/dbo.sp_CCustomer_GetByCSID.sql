SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_GetByCSID */
CREATE Procedure [dbo].[sp_CCustomer_GetByCSID]
	@FaxID varchar(50)
AS

SELECT *
FROM Customer
WHERE FaxID = @FaxID

GO
