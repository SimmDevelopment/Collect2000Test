SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[sp_Master2_Get]
	/* Param List */
AS
select * from Master2 order by Master2ID

GO
GRANT EXECUTE ON  [dbo].[sp_Master2_Get] TO [public]
GO
