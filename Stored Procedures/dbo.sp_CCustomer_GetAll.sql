SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_GetAll */
CREATE Procedure [dbo].[sp_CCustomer_GetAll]
AS

SELECT *
FROM Customer
order by [name]

GO
