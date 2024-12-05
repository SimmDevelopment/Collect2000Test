SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_BranchCode_GetAll*/
CREATE Procedure [dbo].[sp_BranchCode_GetAll]
AS

SELECT *
FROM BranchCodes

GO
