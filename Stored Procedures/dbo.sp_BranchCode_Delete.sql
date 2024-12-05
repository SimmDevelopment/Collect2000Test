SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_BranchCode_Delete*/
CREATE Procedure [dbo].[sp_BranchCode_Delete]
@Code varchar(5)
AS

DELETE FROM BranchCodes
WHERE Code = @Code

GO
