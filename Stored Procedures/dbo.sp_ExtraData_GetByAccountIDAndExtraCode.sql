SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_ExtraData_GetByAccountIDAndExtraCode*/
CREATE Procedure [dbo].[sp_ExtraData_GetByAccountIDAndExtraCode]
@Number INT,
@ExtraCode varchar(2)
AS

SELECT *
FROM extradata
WHERE Number = @Number AND ExtraCode = @ExtraCode

GO
