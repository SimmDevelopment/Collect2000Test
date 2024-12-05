SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Letter_GetByCustomerAndLetterType*/
CREATE Procedure [dbo].[sp_Letter_GetByCustomerAndLetterType]
	@CustomerCode varchar(7),
	@LetterType varchar(3)
AS

SELECT L.*
FROM CustLtrAllow CLA
JOIN Letter L ON CLA.LtrCode = L.Code
WHERE CLA.CustCode = @CustomerCode AND L.Type = @LetterType

GO
