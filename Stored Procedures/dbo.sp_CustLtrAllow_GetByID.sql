SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustLtrAllow_GetByID*/
CREATE Procedure [dbo].[sp_CustLtrAllow_GetByID]
@CustomerCode varchar(7),
@LetterCode varchar(5)
AS

SELECT *
FROM CustLtrAllow
WHERE CustCode = @CustomerCode AND LtrCode = @LetterCode

GO
