SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_BranchCode_GetByID*/
CREATE Procedure [dbo].[sp_BranchCode_GetByID]
@Code varchar(5)
AS

SELECT *
FROM BranchCodes
WHERE Code = @Code

GO
