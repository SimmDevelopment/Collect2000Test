SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_BranchCode_GetByDesk*/
CREATE Procedure [dbo].[sp_BranchCode_GetByDesk]
	@Desk varchar(10)
AS

SELECT *
FROM BranchCodes
WHERE Code = (SELECT Branch FROM Desk WHERE Code = @Desk)

GO
