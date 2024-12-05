SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_GetByCode  */
CREATE Procedure [dbo].[sp_CCustomer_GetByCode]
@Customer varchar(7)
AS

SELECT *
FROM Customer
WHERE Customer = @Customer

GO
