SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[sp_Master2_GetByID]
	@Master2ID int
AS


select * from master2 where master2id = @Master2ID


GO
GRANT EXECUTE ON  [dbo].[sp_Master2_GetByID] TO [public]
GO
