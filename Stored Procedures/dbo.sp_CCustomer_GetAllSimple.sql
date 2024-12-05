SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CCustomer_GetAllSimple */
CREATE Procedure [dbo].[sp_CCustomer_GetAllSimple]
	
AS

--Get just the name and code for fast reader display
SELECT [name], customer FROM Customer 
ORDER BY [name]

GO
