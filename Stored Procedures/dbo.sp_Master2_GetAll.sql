SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[sp_Master2_GetAll]
	/* Param List */
AS
select * from Master2 order by Master2ID
/******************************************************************************
**		File: 
**		Name: sp_Master2_GetAll
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**    
*******************************************************************************/




GO
GRANT EXECUTE ON  [dbo].[sp_Master2_GetAll] TO [public]
GO
